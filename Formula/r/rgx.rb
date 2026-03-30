class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "a997533fd251c846325bc3d7b2d5038be91430826c1a9ecd4ddad8d6036e4012"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea345172bb1da0ae3702d568ed51a4c7a49e626609324486e2dc4a914975fb30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c69957455d63d10c5426dfc59a2352dee3055713e3474ebc80e8eb0ff5464281"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3def2d41c3995b0bd0020d86946120f62b4e653b7e494671cf89be1b2316acd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da69c9f32210727c80c413f497943d9367386cc457f68b5658ab8057af13c35f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faa33e1ee537854c71b0891c99e3413a8d4a45cc5f62e858f10c3a04f1c3a306"
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
