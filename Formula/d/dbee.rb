class Dbee < Formula
  desc "Fast & Minimalistic Database Browser"
  homepage "https://github.com/murat-cileli/dbee"
  url "https://github.com/murat-cileli/dbee/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "4a1994a02dbc1d6f64aa7a2554f0a172603e7ba1f3fe9b4ab4481f1be1182c7f"
  license "GPL-3.0-or-later"
  head "https://github.com/murat-cileli/dbee.git", branch: "main"

  depends_on "go" => :build

  def install
    cd "src" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    ENV["TERM"] = "xterm"

    require "pty"
    output = ""
    PTY.spawn("#{bin}/dbee") do |reader, writer, pid|
      sleep 1
      writer.print "\e"
      writer.puts "yes"
      Process.kill("TERM", pid)
      begin
        reader.each_line { |line| output << line }
        assert_match "Connect to Server", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
