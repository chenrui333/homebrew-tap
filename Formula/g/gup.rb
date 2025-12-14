class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "99271e45e7308636ebca3ba1b80de2cceec45c8b23dca4c2a508972974c58787"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  depends_on "go"

  def install
    ldflags = "-s -w -X github.com/nao1215/gup/internal/cmdinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gup", "completion")
    ENV["MANPATH"] = man1.mkpath
    system bin/"gup", "man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gup version")

    ENV["GOBIN"] = testpath
    cp bin/"gup", testpath

    assert_match "gup: github.com/nao1215/gup", shell_output("#{bin}/gup list")
    system bin/"gup", "remove", "--force", "gup"
    refute_path_exists testpath/"gup"
  end
end
