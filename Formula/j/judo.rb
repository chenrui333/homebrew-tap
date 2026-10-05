class Judo < Formula
  desc "Multi-database TUI for ToDo lists"
  homepage "https://github.com/giacomopiccinini/judo"
  url "https://static.crates.io/crates/judo/judo-2.0.7.crate"
  sha256 "f7b89759622c3e47ee694c87a513d70ebfd02216c8f5be12ca479cd74dfc347c"
  license "MIT"
  head "https://github.com/giacomopiccinini/judo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c583461318c8f87a0a7e9b14e187520dee7fa8da918f9bdfb9a2fd5445c3577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36d898957ce9eb9ea4e045627c8a5426eeff50d41ffe17af7f9ada3e49000cfa"
    sha256 cellar: :any,                 arm64_linux:   "8a248db53a99b6d8917324e5dae04a67ced9f65624e00ac7026520bc858cd351"
    sha256 cellar: :any,                 x86_64_linux:  "b2e57f07bd4e8913891b8a56e7f46e16f75de49f674e08a2be7ec89559062d6b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
