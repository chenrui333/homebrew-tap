# framework: cobra
class Pluralith < Formula
  desc "Tool for Terraform state visualisation and automated generation of infra docs"
  homepage "https://www.pluralith.com/"
  url "https://github.com/Pluralith/pluralith-cli/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "83cbef01a82e15024c20c023e80b11b1f2aa0f878019c486055b604eaafeba07"
  license "MPL-2.0"
  head "https://github.com/Pluralith/pluralith-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcf44646d73cd9f1436479e7ebf6ae6aed37ccdbe3d6f2df91e6b49358ae5e2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f17b58cb40d7c1cb6f4bb9814b62cc462685eb83717a2f2f378fd6974d27b1c"
    sha256 cellar: :any_skip_relocation, ventura:       "a71c9f50ca91d20a850fd12e9219f5afcfc3ed25963872cd6a63eedde450089a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f32aaa1530c7a9007062c76e1c4474e922182c24f88d60792b1f165129a7e9ab"
  end

  depends_on "go" => :build

  def install
    cd "app" do
      system "go", "build", *std_go_args(ldflags: "-s -w")

      generate_completions_from_executable(bin/"pluralith", shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluralith version")

    system bin/"pluralith", "init", "--empty"
    assert_path_exists "pluralith.yml"
  end
end
