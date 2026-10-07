class Termdbms < Formula
  desc "TUI for viewing and editing database files"
  homepage "https://github.com/mathaou/termdbms"
  url "https://github.com/mathaou/termdbms/archive/refs/tags/v0.9-alpha.tar.gz"
  sha256 "7ad5cfb55bcbf7dafb679ae1dfc63ac85de005de6f0a62f494a24f0782008240"
  license "MIT"
  head "https://github.com/mathaou/termdbms.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "786bb3270be0dafefdff1aae4b9c3209a8f20f38433c1d5fb0b7a08f092ede68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "786bb3270be0dafefdff1aae4b9c3209a8f20f38433c1d5fb0b7a08f092ede68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "791922f2349870185000bfc79650a14be9a7c072c247da0f856dd91c558b9c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "762f1038c4c3d5e32e873e6d3107cf7360c0c07d04dd056bf282d02a3daed098"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # Pre-1.17 go.mod omits indirect deps the build needs; fetch the full module graph.
    system "go", "mod", "download", "all"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"
    require "timeout"

    (testpath/"test.csv").write <<~EOS
      id,name,age
      1,Alice,30
      2,Bob,25
    EOS

    output = +""
    PTY.spawn({ "TERM" => "xterm-256color" }, "/bin/sh", "-c",
              "stty cols 120 rows 40; exec #{bin}/termdbms -p test.csv") do |r, w, pid|
      Timeout.timeout(15) do
        loop do
          output << r.readpartial(4096)
          # termenv blocks until the terminal answers its background colour query
          w.write "\e]11;rgb:0000/0000/0000\e\\" if output.sub!("\e]11;?", "")
          w.write "\e[1;1R" if output.sub!("\e[6n", "")
          next unless output.include?("Alice")

          w.write "q"
          break
        end

        loop { output << r.readpartial(4096) }
      rescue EOFError, Errno::EIO
        nil
      ensure
        begin
          Process.kill("TERM", pid)
        rescue Errno::ESRCH
          nil
        end
      end
    end

    assert_match "2 record(s) + 3 column(s)", output
    assert_match "Alice", output
  end
end
