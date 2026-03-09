class Ftdv < Formula
  desc "Terminal-based file tree diff viewer with flexible diff tool integration"
  homepage "https://github.com/wtnqk/ftdv"
  url "https://github.com/wtnqk/ftdv/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "8a0dff5da5c5992f1ee16448974c4fea91bf4df96565305bfe19c4833bdf54e8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/wtnqk/ftdv.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
    generate_completions_from_executable(bin/"ftdv", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ftdv --version")

    bash_completion = shell_output("#{bin}/ftdv completions bash")
    assert_match "_ftdv", bash_completion
    assert_match "status", bash_completion
    assert_match "completions", bash_completion
  end
end
