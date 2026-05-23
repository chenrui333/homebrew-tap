class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "d475073be08b4cad7e1204eb4bb0f3200a18d16f65b7ce5fb2f42cb859a6b1d5"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64d6b4f6bf9b6a3103d0703d8a43a4faeb698a5502542d6f74c3e1bacc0f2be6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c6369216b6eb04e2500a3e287b050ba0913d1d762559c06c07bdf8e042f220f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ece7ffcc6496011d5f76d6dfef2830050fb7ff7ca4b50330dd69a5be8fd8803"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e67ed6193a0fb325a517cf36d9aa0569314013329973ca978ff658bde8e35187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ec64a26c8a11d989a53c68882dfe7ac1b2c5b96bbf3edbbb0ea5b0caf345ac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
    generate_completions_from_executable(bin/"rgx", "--completions")
  end

  test do
    assert_equal "42\n99\n", shell_output("#{bin}/rgx -p -t 'hello 42 world 99' '\\d+'")
    assert_equal "3\n", shell_output("#{bin}/rgx -p -c -t 'a1 b2 c3' '\\d+'")
  end
end
