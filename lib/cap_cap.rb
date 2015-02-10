require "tempfile"
require "optparse"

require "capybara"
require "capybara/poltergeist"

require "cap_cap/version"

Capybara.register_driver :poltergeist do |app|
  opt = {
    phantomjs_logger: File.open(File::NULL, "w"),
    js_errors: false,
    phantomjs_options: [
      '--ignore-ssl-errors=true', # Enable access to the local env which has invalid ssl certificate
      '--web-security=false', # Suppress warnings caused by adlantis js
    ]
  }
  opt[:logger] = File.open(ENV["POLTERGEIST_LOG"], "w") unless ENV["POLTERGEIST_LOG"].nil?
  Capybara::Poltergeist::Driver.new(app, opt)
end
Capybara.default_driver = :poltergeist

module CapCap
  def CapCap.run
    opts = {headers: []}
    opt = OptionParser.new
    opt.banner = "Usage: capcap [options] <url> [<url>...]"
    opt.on("-o", "--output=VAL", "Output capturing image to specific path. If ommited, output to tempfile.") {|v| opts[:output] = v }
    opt.on("-s", "--selector=VAL", "Capture only element specified by css selector. If ommited, capture entire page.") {|v| opts[:selector] = v }
    opt.on("-H", "--header=VAL", "Add extra HTTP-header to use when getting a web page.") {|v| opts[:headers] << v }
    opt.on("--size=VAL", "Specify rendering page size. If ommited, it may be default size. e.g., `--size 320x480`") {|v| opts[:size] = v.split(?x).map(&:to_i) }
    opt.on("--open", "If specified, invoke `open` command to preview captured image.") {|v| opts[:invoke_open] = v }
    opt.parse! ARGV

    main = Main.new
    main.resize *opts[:size] unless opts[:size].nil?
    if opts[:headers].size > 0
      main.add_headers Hash[opts[:headers].map {|v| v.split(?:).map{|kv| kv.strip } }]
    end

    if ARGV.empty?
      puts opt.help
      exit
    elsif ARGV.size == 1
      output = main.capture ARGV.first, opts[:output], selector: opts[:selector]
      main.invoke_open output if opts[:invoke_open]
    else
      outputs = ARGV.map {|url| main.capture url, selector: opts[:selector] }
      output = main.capture_combined outputs, opts[:output]
      main.invoke_open output if opts[:invoke_open]
    end
  end

  class Main
    include Capybara::DSL

    def capture url, output = nil, selector: nil
      visit url
      output = Tempfile.open(["capcap", ".png"]).path if output.nil?
      opt = if selector.nil? then {full: true} else {selector: selector} end
      save_screenshot output, opt
      output
    end

    def invoke_open path
      `open #{path}`
      sleep 2
    end

    def capture_combined outputs, output = nil
      visit "about:blank"
      output = Tempfile.open(["capcap", ".png"]).path if output.nil?

      imgs = outputs.map {|src| %Q|<img src="file://#{src}" />| }
      html = %Q|<table id="canvas" border=0><tr><td valign=top>#{imgs.join("</td><td valign=top>")}</td></tr></table>|
      script = %Q|document.body.innerHTML = '#{html}';|
      evaluate_script script

      save_screenshot output, selector: "#canvas"
      output
    end

    def add_headers headers
      page.driver.add_headers headers
    end

    def resize w, h
      page.driver.resize w, h
    end
  end
end
