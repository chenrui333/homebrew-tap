class Pluralith < Formula
  desc "Tool for Terraform state visualisation and automated generation of infra docs"
  homepage "https://www.pluralith.com/"
  url "https://github.com/Pluralith/pluralith-cli/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "83cbef01a82e15024c20c023e80b11b1f2aa0f878019c486055b604eaafeba07"
  license "MPL-2.0"
  head "https://github.com/Pluralith/pluralith-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    cd "app" do
      system "go", "build", *std_go_args(ldflags: "-s -w")

      generate_completions_from_executable(bin/"pluralith", "completion")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluralith version")

    system bin/"pluralith", "init", "--empty"
    assert_path_exists "pluralith.yml"
  end
end
