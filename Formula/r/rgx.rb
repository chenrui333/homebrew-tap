class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "f2e4e24ed3a3c0f4951796ef79e47b892a20e222bd35272b1f5b9c5b1f57a611"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07a206eee70830a7a6a49fd3384cd5423578d5418240034b9eec395a5a18a225"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07bbc66a2728c87ed5ada3faae716b81dfcf215037b4956bc1d4ed7990aead8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f80894d959d57b2ff5d920e0386c1a8449571f2d99909f8a39e1014015147190"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "612519513c88ed0528a28ca12604cde8ccb7b671fa00e798cca299e06d04747d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efe19aa80a3b6d3886cad4817612d56867a4b2bc26de9c1ef430706aee528e72"
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
