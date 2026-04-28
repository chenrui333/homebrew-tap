class Dbee < Formula
  desc "Fast & Minimalistic Database Browser"
  homepage "https://github.com/murat-cileli/dbee"
  url "https://github.com/murat-cileli/dbee/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "4a1994a02dbc1d6f64aa7a2554f0a172603e7ba1f3fe9b4ab4481f1be1182c7f"
  license "GPL-3.0-or-later"
  head "https://github.com/murat-cileli/dbee.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "886526a70a83380147335f8914b9766de45cc74fbb7e73bd3dca75ae09537695"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "753f95855d36463a4043da50067e501e3da806c2a41ace3e64f5d2cb3791d8fd"
    sha256 cellar: :any_skip_relocation, ventura:       "5714ad5a05eb7a62b721b77128e08b1f2d2cb53eb5ed391dd395da76b1540ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49c4f46a8537b352c66ac0c6045afc5fbff56bcdefdd2693634f8c394a929ec6"
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
