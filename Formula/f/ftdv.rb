class Ftdv < Formula
  desc "Terminal-based file tree diff viewer with flexible diff tool integration"
  homepage "https://github.com/wtnqk/ftdv"
  url "https://github.com/wtnqk/ftdv/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "8a0dff5da5c5992f1ee16448974c4fea91bf4df96565305bfe19c4833bdf54e8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/wtnqk/ftdv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e0ec21f922d9dc0894012d6729c16d24320fed26d612032402e3c70d051d370"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53afc94de5db630c1a1aebb72c41931203252e46c74a3ea0b977bb1045c3a338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4976b01d6a5bcb0279a214f963c22d4c41ea2785562c17c2cdd32d3b736f18f"
    sha256 cellar: :any,                 arm64_linux:   "9c544c28ccfcd9fe310386c322e4928c4e0cb57660c41af66b9cd71442396738"
    sha256 cellar: :any,                 x86_64_linux:  "927f059984d0d314d0c8f7078dad20075b4f28fcf1f650378ce6e71a61da60b8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ftdv", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ftdv --version")

    output = shell_output("#{bin}/ftdv --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
