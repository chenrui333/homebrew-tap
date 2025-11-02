class Schema < Formula
  desc "CLI tool for the database | SQLite, libSQL, PostgreSQL, MySQL, MariaDB"
  homepage "https://schema.gigagrug.com/"
  url "https://github.com/gigagrug/schema/archive/refs/tags/0.5.1.tar.gz"
  sha256 "c6234258d9429fd93cb32d8463d8bbf2126b6bd7a59278c89be199e2d2be757e"
  license "Apache-2.0"
  head "https://github.com/gigagrug/schema.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/schema -v")

    assert_match "Schema successfully initialized", shell_output("#{bin}/schema -i")
    assert_path_exists testpath/".env"

    assert_match "No pending migrations found", shell_output("#{bin}/schema -migrate")
    assert_path_exists testpath/"schema/db.schema"
  end
end
