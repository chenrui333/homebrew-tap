class Lazycli < Formula
  desc "Turn static CLI commands into TUIs with ease"
  homepage "https://github.com/jesseduffield/lazycli"
  url "https://github.com/jesseduffield/lazycli/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "66f4c4c5bedf4d3ceb35aebc1d7f18663c7250ac47241fea18108c0741bf2019"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/lazycli --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"lazycli", "--", "ls", "-l", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "No profile selected", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
