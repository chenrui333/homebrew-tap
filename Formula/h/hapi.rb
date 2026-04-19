class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.16.7.tgz"
  sha256 "071327841df03100071bff2029ee68906ddf4b65f362b887413bb25e2014a782"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "50dff64bfb9b64eafa630101aab5fb3366160b28140f8ca1efd00a2e4790aff3"
    sha256                               arm64_sequoia: "50dff64bfb9b64eafa630101aab5fb3366160b28140f8ca1efd00a2e4790aff3"
    sha256                               arm64_sonoma:  "50dff64bfb9b64eafa630101aab5fb3366160b28140f8ca1efd00a2e4790aff3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01562bc66f1fd6ddedc1572497f9a376fb83789ac6f359504bf037d83edc7173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "628076ea51af5fa29686cf1b6963e78b3eacaa305f90dbe575aee49ef36e54ec"
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
