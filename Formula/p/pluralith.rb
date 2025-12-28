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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3548dbf1f3c610fb2ce572348c50bd8a48d04dd5373caa6477d89564a6e9ad06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3548dbf1f3c610fb2ce572348c50bd8a48d04dd5373caa6477d89564a6e9ad06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3548dbf1f3c610fb2ce572348c50bd8a48d04dd5373caa6477d89564a6e9ad06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68a7181bc9f8d5b569d17110964a9cd3f28926d0a73f62801aedd56403d07334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "015cf9b35876d0bc6ddda474e44d203899205b2ddc64764cab0fc4977cb9474d"
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
