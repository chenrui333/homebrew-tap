class Judo < Formula
  desc "Multi-database TUI for ToDo lists"
  homepage "https://github.com/giacomopiccinini/judo"
  url "https://static.crates.io/crates/judo/judo-2.0.7.crate"
  sha256 "f7b89759622c3e47ee694c87a513d70ebfd02216c8f5be12ca479cd74dfc347c"
  license "MIT"
  head "https://github.com/giacomopiccinini/judo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dc46bc3f3294bec1010b52411071f4e357e78fff9e0145f3d47e74209da4f2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af6b96885fcd75aa8171a0d31aea80ee9fb9a0616357296c1b5b564c86cff19c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c679b473cf582e6632d9924354e64dd1d50a7b855e5b9c5bff73301b480b84e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6f79389d404623ad329a85878b3b4230c41b20008fe1d3fc77414e1316ca9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b85b13e39ad310248729e2ee5c341c3fb48a0620a17a2d543a5f451482b209"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/judo --version")

    db_name = "testdb#{Process.pid}"
    list_name = "inbox#{Process.pid}"
    item_name = "task#{Process.pid}"

    system bin/"judo", "dbs", "add", "--name", db_name
    system bin/"judo", "lists", "add", "--name", list_name, "--db", db_name
    system bin/"judo", "items", "add", "--name", item_name, "--db", db_name, "--list-name", list_name

    output = shell_output("#{bin}/judo items show")
    assert_match item_name, output
    assert_match list_name, output
    assert_match db_name, output
  end
end
