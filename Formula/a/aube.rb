class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "7ced31d0e28ec3750dd0464274035778d62f7549fcc0504fcef95b270936c020"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e12a76b169a959cc43933dc5140a0bc16477318c70682a393188772a91427434"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06ba890b950943d5d01378df3b939db5c911ac29d0c05599dfa410d905a2389e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df988be2f2bc7302a765e8ca1b68e77ed0e5e62f40227d59ab10430861a8b2d2"
    sha256 cellar: :any,                 arm64_linux:   "138e53c6d2a3ab1d1cae09a7edc63b3f7414838d0a2230d16afafcbdc6a058b5"
    sha256 cellar: :any,                 x86_64_linux:  "b75d2f26f2c6e91d58bdd8296add8c020ad73c3a621fac81f2de3cdc84f47eec"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")

    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aube --version")
    assert_match "Usage", shell_output("#{bin}/aubr --help")
    assert_match "Usage", shell_output("#{bin}/aubx --help")

    (testpath/"package.json").write('{"name":"test","version":"0.0.1"}')
    system bin/"aube", "install"
  end
end
