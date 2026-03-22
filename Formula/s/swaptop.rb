class Swaptop < Formula
  desc "TUI for monitoring swap usage"
  homepage "https://github.com/luis-ota/swaptop"
  url "https://github.com/luis-ota/swaptop/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "20bcd3b83e7fe29100771d4adc932cec9c8c14e1361be7c7608d70ba515af80f"
  license "MIT"
  head "https://github.com/luis-ota/swaptop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "277eff7949f90412a3bf132140cf0f49719763570ca1fc5d77b8166927e71137"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f8f897a5653a3f693f4e35aad0d9d0ccb20ec3ca77538debfbebe67059ffa674"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    if ENV["HOMEBREW_GITHUB_ACTIONS"]
      output = shell_output("#{bin}/swaptop --version 2>&1", 101)
      assert_match "failed to initialize terminal", output
    end
  end
end
