class Taws < Formula
  desc "Terminal-based AWS resource viewer and manager"
  homepage "https://github.com/huseyinbabal/taws"
  url "https://github.com/huseyinbabal/taws/archive/refs/tags/v1.3.0-rc.7.tar.gz"
  sha256 "c6bd15c5541a4b6a4accb780128642f0cca78c43c741adfbade48062a8f96b51"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
    generate_completions_from_executable(bin/"taws", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taws --version")

    output = shell_output("#{bin}/taws completion bash")
    assert_match "taws__completion", output
    assert_match "--profile", output
  end
end
