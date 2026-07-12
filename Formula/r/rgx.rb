class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "0a0c8b8b0e5d7c99626e1609affd4d3a9bfbe0af5452a379f0baa4502fa5b4e3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "300cc0b5bbb35d9d51d57f052b3364c79dbb4707faeb56153a6fc663a4742bb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cfe660962cb60d227aa000657ba2633271e2429a39694764da265d522bd5819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e5c7f7799f6ee35d1f178677437246dfc763e64ad2947fe6e6c46e37aa410b6"
    sha256 cellar: :any,                 arm64_linux:   "3a5d196c80ca92cade6c1afa439ee6974eddadc83c5852d09fdfa1f3d2db97bc"
    sha256 cellar: :any,                 x86_64_linux:  "7e5b9c7614a5d0f42d604ad037f746e1169017e4e6100fa7a001f628eabd96a1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rgx", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rgx --version")

    assert_equal "42\n99\n", shell_output("#{bin}/rgx -p -t 'hello 42 world 99' '\\d+'")
    assert_equal "3\n", shell_output("#{bin}/rgx -p -c -t 'a1 b2 c3' '\\d+'")
  end
end
