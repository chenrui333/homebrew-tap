class Mcman < Formula
  desc "Powerful Minecraft Server Manager CLI"
  homepage "https://mcman.deniz.blue/"
  url "https://github.com/ParadigmMC/mcman/archive/refs/tags/0.4.5.tar.gz"
  sha256 "eed1795604826be9018d00965c34031e2b7e2a25f01ea928066d37816fba4e13"
  license "GPL-3.0-only"
  head "https://github.com/ParadigmMC/mcman.git", branch: "main"

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
