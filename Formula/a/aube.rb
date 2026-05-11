class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "21d3bc80bdd2a7f6dd91edfcf3a338f5becc8c305d76ed07b23908aaea242dc3"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e15affbda7a15f0f55d48a9601e9d812f8f8b84cb1b53844428dc9887cc20bba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faef99ad4558e436f5814cb204e14f388f946801fa2ba290858b4647391c6e72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b320337d3b0283d49801c062fcb45779bb1220586bd5c33b2497b5524ef3d7f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aac8295df250803fef313be024c6590b1e9a94d0c41e584997c6a87f0a1ace23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "395465f5d2408cd6b25d177f867a52aab57f8d4ee2c1421998ed835c7659ce75"
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
