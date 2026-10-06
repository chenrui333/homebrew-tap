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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "644b6dabf3f9f30aec07c9d3599f9528ce0326ef4abb5f6a6e426ef96776125f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "644b6dabf3f9f30aec07c9d3599f9528ce0326ef4abb5f6a6e426ef96776125f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1896d4b3b4d58123a2cf4680eb5863af79549876870bcc92f6223ead01a105a"
    sha256 cellar: :any,                 x86_64_linux:  "3deafa1a5ab07a94898c5552070025ef18e70eb339c4cc8ce29c1bd1ec791246"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "app" do
      system "go", "mod", "download"
    end
  end

  def install
    # Skip the graph-module update check on every startup: it calls the now-dead
    # api.pluralith.com, panics (nil response) without network and writes to stdout.
    # `pluralith install` and `pluralith update` still run it on demand.
    inreplace "app/main.go" do |s|
      s.gsub! "\t\"pluralith/pkg/install/components\"\n", ""
      s.gsub! "\tcomponents.GraphModule(true)\n", ""
    end

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
