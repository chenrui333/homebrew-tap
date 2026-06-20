class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "30a0c13008853af2502451fa3449f211e422946756c0c28a50c520ce0a540851"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a4326d5e03a2a4c22b93621808b6cbdbed784ae7543eed635c70e0a1a22b837"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4a362c2469ceca1e2e8c7d3712fa4fc07d7091155219438050cc26354d84659"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7e1a1753fdc52322799d2525315b651575db158f7372dabdf7aefd1f7906cc6"
    sha256 cellar: :any,                 arm64_linux:   "c0b6444b85161b24ae5938e3a8d633b5b20d4e55b6b04c35672caddb979e77a1"
    sha256 cellar: :any,                 x86_64_linux:  "2a6cf9d38b4e66830d4bb3ac07433a4ffaf61f5cb990eafaad08007079932dce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rgx", "--completions")
  end

  test do
    assert_equal "42\n99\n", shell_output("#{bin}/rgx -p -t 'hello 42 world 99' '\\d+'")
    assert_equal "3\n", shell_output("#{bin}/rgx -p -c -t 'a1 b2 c3' '\\d+'")
  end
end
