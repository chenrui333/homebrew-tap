class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.12.9.tar.gz"
  sha256 "ce264c417c7a3c8c12c93c793073cdc2964d2ef2c472289e5da9612e056f152f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9e5afebb52ef3357ebf1fb97e118832034f18878249ee459d77ae85129f66cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae2428a39d52a8df0b61383fc5090778ff4e28610e15354fc118307f0c18e2e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7788463fcda9faf05a16cf1cdbf4f279005b0efee50fea535defb56aca41f8d4"
    sha256 cellar: :any,                 arm64_linux:   "4f6a60a6797501ff4909c66291094537f771350fe17f8db6799e78986022d5e9"
    sha256 cellar: :any,                 x86_64_linux:  "d003d32c6e4bce51ce4e9ce635b797bbbc4aa33f5b6aa8db389cfd2e16c0993c"
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
