class Tempo < Formula
  desc "Terminal client for Temporal"
  homepage "https://github.com/galaxy-io/tempo"
  url "https://github.com/galaxy-io/tempo/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "1052981f2561f79cd985c661fbcd48e8b7fa2951504bec402864c875c258f566"
  license "MIT"
  head "https://github.com/galaxy-io/tempo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce38ff3b9102c0d87662e847918c03134303155f0ab7fb0be39793dbdea3f537"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce38ff3b9102c0d87662e847918c03134303155f0ab7fb0be39793dbdea3f537"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce38ff3b9102c0d87662e847918c03134303155f0ab7fb0be39793dbdea3f537"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d87cfd2119d7203e28c3e9baa1d0a68ef009f616a3e6b4718371a5a5a9ddf0a"
    sha256 cellar: :any,                 x86_64_linux:  "939779d6becc2d80d6634c1f309b1311adcac575b08620535872e76efeb2dd89"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/galaxy-io/tempo/internal/update.Version=#{version}"), "./cmd/tempo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tempo --version")
    output = shell_output("#{bin}/tempo --profile homebrew-missing 2>&1", 1)
    assert_match 'profile "homebrew-missing" not found', output
  end
end
