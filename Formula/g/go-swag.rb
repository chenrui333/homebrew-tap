class GoSwag < Formula
  desc "Automatically generate RESTful API documentation with Swagger 2.0 for Go"
  homepage "https://github.com/swaggo/swag"
  url "https://github.com/swaggo/swag/archive/refs/tags/v1.16.6.tar.gz"
  sha256 "d0193f08b829e1088753ff6d66d1205e22a6e7fd07ac28df5ecb001d9eb2c43d"
  license "MIT"
  head "https://github.com/swaggo/swag.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46761fa0ab92f2ac2d70e393d1b6ae827767ed54a06fa191702abec392a61f71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88c297dc1713f5aa549f3051d16297f82e29034b78b5cd59357f364e606bd220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f082b5e29b0712be7c9a74b638fc33e07b0b419cd808501086e709ed34ee1b4"
  end

  depends_on "go" => :build

  def install
    # version patch PR, https://github.com/swaggo/swag/pull/2049
    # bug report, https://github.com/swaggo/swag/issues/2077
    inreplace "version.go", "1.16.4", version.to_s
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"swag"), "./cmd/swag"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/swag --version")

    (testpath/"main.go").write <<~GO
      // Package main Simple API.
      // @title Simple API
      // @version 1.0.0
      // @description This is a simple API server.

      // @host localhost:8080
      // @BasePath /api/v1

      package main

      import "github.com/gin-gonic/gin"

      func main() {
        r := gin.Default()
        r.GET("/ping", func(c *gin.Context) {
          c.JSON(200, gin.H{"message": "pong"})
        })
        r.Run()
      }
    GO

    system bin/"swag", "init"
    assert_path_exists testpath/"docs/docs.go"
    assert_path_exists testpath/"docs/swagger.json"
  end
end
