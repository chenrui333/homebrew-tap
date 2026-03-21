class Tascli < Formula
  desc "Track tasks and records from the terminal"
  homepage "https://github.com/Aperocky/tascli"
  url "https://github.com/Aperocky/tascli/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "0ddaae7fc8a18020fb4cf67f82705cff351e79e15c4109e7fe0fd533f43d31f3"
  license "MIT"
  head "https://github.com/Aperocky/tascli.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    task_content = "Write formula test"

    assert_match version.to_s, shell_output("#{bin}/tascli --version")

    system bin/"tascli", "task", "-c", "work", task_content, "today"

    output = shell_output("#{bin}/tascli list task -c work")
    assert_match task_content, output
    assert_match "work", output
    assert_path_exists testpath/".local/share/tascli/tascli.db"
  end
end
