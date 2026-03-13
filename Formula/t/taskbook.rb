class Taskbook < Formula
  desc "Tasks, boards & notes for the command-line habitat"
  homepage "https://taskbook.sh"
  url "https://github.com/taskbook-sh/taskbook/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "53d84220f004cd5c91b3293d1ca9eba60ea54b9f15e3dc40ff45530b9957ac4b"
  license "MIT"
  head "https://github.com/taskbook-sh/taskbook.git", branch: "master"

  depends_on "rust" => :build

  def install
    ENV["CARGO_TARGET_DIR"] = buildpath/"target"

    system "cargo", "install", *std_cargo_args(path: "crates/taskbook-client")
    system "cargo", "install", *std_cargo_args(path: "crates/taskbook-server")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tb --version")

    system bin/"tb", "--cli", "--taskbook-dir", testpath, "--task", "Ship formula"
    output = shell_output("#{bin}/tb --cli --taskbook-dir #{testpath} --list pending")
    assert_match "Ship formula", output
  end
end
