class Bbrew < Formula
  desc "Bold Brew (bbrew) - A Homebrew TUI Manager"
  homepage "https://bold-brew.com/"
  url "https://github.com/Valkyrie00/bold-brew/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "6897d9eefd4355cb8160379138b7b96fbac9d647a51f3c43427fc3904e9b2dda"
  license "MIT"
  head "https://github.com/Valkyrie00/bold-brew.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7909609b570748693d73b01f3df7274cfa2ec8200161612d5580e083a30454b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7909609b570748693d73b01f3df7274cfa2ec8200161612d5580e083a30454b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7909609b570748693d73b01f3df7274cfa2ec8200161612d5580e083a30454b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b34fb33416e1c75bfaeacbc7f17d4885d16395d94d2af3802df3dc2a201b191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6757ef20a9c19f4720b5bca25d3c0479d10c3512344d9be84b94770bef0ca418"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X bbrew/internal/services.AppVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bbrew"
  end

  test do
    (testpath/"Brewfile").write <<~EOS
      brew "wget"
    EOS

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"bbrew", "-f", testpath/"Brewfile", [:out, :err] => output_log.to_s
      sleep 8
      assert_match "Application error: terminal not cursor addressable", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
