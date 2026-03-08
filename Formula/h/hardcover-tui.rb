class HardcoverTui < Formula
  desc "Terminal UI client for Hardcover.app"
  homepage "https://github.com/NotMugil/hardcover-tui"
  url "https://github.com/NotMugil/hardcover-tui/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "fa230e92bc28cde6f7f49aa0489834d9060f7935815a92a1e95d3853b100c838"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/NotMugil/hardcover-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baecd7d47fc884111c65bc8defd08aa6e82e8dd198d517710e083649ce9c3c57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baecd7d47fc884111c65bc8defd08aa6e82e8dd198d517710e083649ce9c3c57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baecd7d47fc884111c65bc8defd08aa6e82e8dd198d517710e083649ce9c3c57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9febcb8b9c6ad176f906ea6355555f30bddb01196f0383fa0d9444c735152855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a89bd261c81072082bb8ef849a44ede6267ab36aa7b0d06a0af9d638874a694"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hardcover-tui"
  end

  test do
    require "pty"
    require "timeout"

    assert_match version.to_s, shell_output("#{bin}/hardcover-tui --version")

    output = +""
    PTY.spawn({ "HOME" => testpath.to_s, "TERM" => "xterm-256color" }, (bin/"hardcover-tui").to_s) do |r, w, _pid|
      Timeout.timeout(15) do
        loop do
          output << r.readpartial(1024)
          next unless output.include?("Enter your API token:")

          w.write("\u0003")
          break
        end

        loop { output << r.readpartial(1024) }
      rescue EOFError, Errno::EIO
        nil
      end
    end

    assert_match "Enter your API token:", output
  end
end
