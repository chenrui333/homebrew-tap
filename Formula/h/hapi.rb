class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.17.4.tgz"
  sha256 "4870b2e335cdb92452422af5960b59d8d15388858f6f5bfb6b8a137440aa04f6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "4221ef32c7ae8d935384047f9ae40a5edfb0cdd42454102027fb55887b8b4975"
    sha256                               arm64_sequoia: "4221ef32c7ae8d935384047f9ae40a5edfb0cdd42454102027fb55887b8b4975"
    sha256                               arm64_sonoma:  "4221ef32c7ae8d935384047f9ae40a5edfb0cdd42454102027fb55887b8b4975"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6c4ff560cbe8eead536f5fb75c7785d0cdb982a68f89039ffae27e30f62ae05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f1833ed99b29400c05efc5613dd6e8a3a93d406af735f351cbb4d6613ba71d9"
  end

  depends_on "node"

  def install
    # Required for the platform-specific optional binary package on CI mirrors.
    ENV["npm_config_registry"] = "https://registry.npmjs.org"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
  end
end
