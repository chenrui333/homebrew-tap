class Schema < Formula
  desc "CLI tool for the database | SQLite, libSQL, PostgreSQL, MySQL, MariaDB"
  homepage "https://schema.gigagrug.com/"
  url "https://github.com/gigagrug/schema/archive/refs/tags/0.7.0.tar.gz"
  sha256 "25873581dc0037eb0e348d23e248dd033120570d1695623025a166ddc704e1aa"
  license "Apache-2.0"
  head "https://github.com/gigagrug/schema.git", branch: "main"

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
