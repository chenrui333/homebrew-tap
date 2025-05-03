class Mcman < Formula
  desc "Powerful Minecraft Server Manager CLI"
  homepage "https://mcman.deniz.blue/"
  url "https://github.com/ParadigmMC/mcman/archive/refs/tags/0.4.5.tar.gz"
  sha256 "eed1795604826be9018d00965c34031e2b7e2a25f01ea928066d37816fba4e13"
  license "GPL-3.0-only"
  head "https://github.com/ParadigmMC/mcman.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cd8c04ac2c550c63535162a512238d832e735a1b008d38efe056278d9b47631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8ef8a6291d3425bbc057717bcdd0ffb288522bf5bb05c21c2f0213d05223a47"
    sha256 cellar: :any_skip_relocation, ventura:       "019ad1ab6d540ff1573aac24b4f9003feaf5c4d77d8d27c16a97991b32bb976e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3007ef72b2af5a94b1b06da54b9b966495fd69320e289fb544e188993ad011a3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "update", "-p", "time"
    odie "Remove time crate update line!" if version > "0.4.5"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcman --version")

    (testpath/"server.toml").write <<~TOML
      [[clientsidemods]]
      type = "modrinth"
      id = "3dskinlayers"
      version = "JHapWF9O"
      optional = true
      desc = "It adds 3D skin layers :moyai:"
    TOML

    assert_match "Type   : Vanilla", shell_output("#{bin}/mcman info")
  end
end
