class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "d6be1acb58c18f875ee0c6cd8e24d16729ce96d89ee864198fe7ab767f127631"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3991ca7f5294838c6429379861ab2ed757456de933bd0e11f63634d63a7eab9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb33ad0ec2d9b2fcb22b3508a1c0484068f32e93dcdc21e8e9389f2aafdcdc0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51efdc4e66caabb22841d11c6ac73bf656152353af7667909464782b3728b865"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c3832dfbacdc5795321fcd98e9ce3634d395de26495005fd5ebe63a3bf8c170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9311e3d43e226a5eba2ef965cfecb334b83790270c1bbef7b51b674541c03afa"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
