class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "0b3f7db478d5b3c83e3e51c671b42d339fa48dc23d94d2ef0e87f51dd6c98b9d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fc5d04ad9fac75edec3fecacf070c37bd1f37d4e10fe632fea9d3b849c9cc90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b18f19f18fcb11b527809295140c8fb412ad81b43c96c2d67c20f32770e3dd8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b061dffb51d52668553191b1e18a538c2ba71b7e1d097916ae257bc1a2f7f3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "173a7eb74bd97498fc831ba28bb390426874afad5acd3c33286fc089f00549b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "458acac1f139d6ef3e635608e7bfc6c8f683b6eb218cc87d229b4ebcd95878b2"
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
