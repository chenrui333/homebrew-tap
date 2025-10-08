class Dbee < Formula
  desc "Fast & Minimalistic Database Browser"
  homepage "https://github.com/murat-cileli/dbee"
  url "https://github.com/murat-cileli/dbee/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "4a1994a02dbc1d6f64aa7a2554f0a172603e7ba1f3fe9b4ab4481f1be1182c7f"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/murat-cileli/dbee.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d11c23c976c685cef5034c5d95dfa184166a1184b959822c57cd35b39a7c3cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d11c23c976c685cef5034c5d95dfa184166a1184b959822c57cd35b39a7c3cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d11c23c976c685cef5034c5d95dfa184166a1184b959822c57cd35b39a7c3cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f52731eebdd10ed82a6bcf3b18583c90ff4ca9a6cd89fac6b5d2e5e8d4bca5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "845a67cd4e2775ebc276e694164831612bc5b6e6b7c340a926cf2f9367f791c9"
  end

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
