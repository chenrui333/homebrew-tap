class Judo < Formula
  desc "Multi-database TUI for ToDo lists"
  homepage "https://github.com/giacomopiccinini/judo"
  url "https://static.crates.io/crates/judo/judo-2.0.7.crate"
  sha256 "f7b89759622c3e47ee694c87a513d70ebfd02216c8f5be12ca479cd74dfc347c"
  license "MIT"
  head "https://github.com/giacomopiccinini/judo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53de8b2988e3233964f420e08cc2f72a917971996b579e5a6da7c89c26ac6bbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "948668d544b8a169530f859421e8d09232791d03c45bc55ecb99280703696b27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0ceccab88b83a0b6e52e69fa5ce19624d271b06eacbc61737346305f9bf60e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "920b8138ad4b6b12b912f15a4bd096f79be0e788522fcdc0ac02715a4dc592e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad0522b4fe0306e79cedfac38898d6b5666a9cc0b7f1b4cc752cf6d5543835b6"
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
