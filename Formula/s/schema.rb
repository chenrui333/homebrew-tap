class Schema < Formula
  desc "CLI tool for the database | SQLite, libSQL, PostgreSQL, MySQL, MariaDB"
  homepage "https://schema.gigagrug.com/"
  url "https://github.com/gigagrug/schema/archive/refs/tags/0.7.0.tar.gz"
  sha256 "25873581dc0037eb0e348d23e248dd033120570d1695623025a166ddc704e1aa"
  license "Apache-2.0"
  head "https://github.com/gigagrug/schema.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1607ff84f13c5c833e5acaeb81b2e63f7f1bd450ed0978e734abe4390e87686b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fe2b90b030f0b7e902a43c4b3f07eae4cc5dd2df7f0f3455104dcba990a2424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc915d7c04d39911b763067ff20ba58d37c01201ec29fd7ff8c6f1684a56baca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f98d26cfa813dadd084c042b0d0faf9cb0332e180ebe6ed70090c03f85386ead"
    sha256 cellar: :any,                 x86_64_linux:  "0b7dfa5d1407ba960996bec3c2ee3c896a14f8f14168118da2fc61444baf3913"
  end

  depends_on "go" => :build

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
