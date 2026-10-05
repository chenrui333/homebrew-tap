class Mcman < Formula
  desc "Powerful Minecraft Server Manager CLI"
  homepage "https://mcman.deniz.blue/"
  url "https://github.com/ParadigmMC/mcman/archive/refs/tags/0.4.5.tar.gz"
  sha256 "eed1795604826be9018d00965c34031e2b7e2a25f01ea928066d37816fba4e13"
  license "GPL-3.0-only"
  head "https://github.com/ParadigmMC/mcman.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5743beea4d6de7ac16f235c0e2d9a338ae32bd7d6306beb542f1cd62bc124ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dba5d3c7b4a2a388491026a0ddfe72c5f791af804c29e81f31f4dc1a4dfd82f"
    sha256 cellar: :any,                 arm64_linux:   "c53c233c47a379ce8e21dfe861c302f60875c4cabc578a5dd5f6b8d13244425d"
    sha256 cellar: :any,                 x86_64_linux:  "03c274f857a173501a89c1006157ecf6a33dd968d126d6508da25defc8def9ad"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "update", "-p", "time"
    odie "Remove time crate update line!" if version > "0.4.5"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
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
