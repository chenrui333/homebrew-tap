class StyleDictionary < Formula
  desc "Build system for creating cross-platform styles"
  homepage "https://github.com/style-dictionary/style-dictionary"
  url "https://registry.npmjs.org/style-dictionary/-/style-dictionary-5.0.0.tgz"
  sha256 "f8ee73b6b55f75db63eab440f2a72a91efd2fb175baf168294dd067ed63e3bf5"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1d5df6bb5e0b868b64c84562841a538b7a9f9f52c592889aa7c945ee4fcbf38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b35206643b1367f572032170a154a678bdc59711a6b4aeefc1767ae1e8164f1"
    sha256 cellar: :any_skip_relocation, ventura:       "1c3f66d883f2b06903430cf3d4832ff2c237244759ed1ccba48836668f2f7781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa2528418424c7c7b6a404f723c072fe75011077c2fe7e0f26551f7ee4375976"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/style-dictionary --version")

    system bin/"style-dictionary", "init", "basic"
    assert_path_exists testpath/"config.json"

    system bin/"style-dictionary", "build"
  end
end
