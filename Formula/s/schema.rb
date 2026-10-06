class Schema < Formula
  desc "CLI tool for the database | SQLite, libSQL, PostgreSQL, MySQL, MariaDB"
  homepage "https://schema.gigagrug.com/"
  url "https://github.com/gigagrug/schema/archive/refs/tags/0.7.0.tar.gz"
  sha256 "25873581dc0037eb0e348d23e248dd033120570d1695623025a166ddc704e1aa"
  license "Apache-2.0"
  head "https://github.com/gigagrug/schema.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d3524063a98fb8b413bb12d61e3be760cdfe04a2f2d5428a4d9820f53f9f39a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ebc20234d0b1bec1542b1e06dae680776e1582475166102e3ce53ff08c4b88f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f3c18a8aafc96f9388e4738cf2b74769305c366e57c746558272afe38e3dd65"
    sha256 cellar: :any,                 x86_64_linux:  "19b9c1e6f42dd0750007bbae399e014ceb6fa064b93589593b100dbcd0f965f6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    require "open3"

    output, = Open3.capture2e(bin/"schema", "version")
    assert_match version.to_s, output

    assert_match "Schema successfully initialized", shell_output("#{bin}/schema init")
    assert_path_exists testpath/".env"

    assert_match "No pending migrations found", shell_output("#{bin}/schema migrate")
    assert_path_exists testpath/"schema/db.schema"
  end
end
