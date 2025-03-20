class Ni < Formula
  desc "Use the right package manager"
  homepage "https://github.com/sindresorhus/ni"
  url "https://registry.npmjs.org/@antfu/ni/-/ni-24.3.0.tgz"
  sha256 "5a076b98f91dde1ec211ee5c151994f45e315c2dc4eca37636a8cdbf4195b881"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1965d1bbb4293e627018efa3f52616a9d2d42f9ecfb9db79708180c4509cd3b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ecad8919f0c7377d28bc3da89eb36d9bdaa798304a707803612e73acc370831"
    sha256 cellar: :any_skip_relocation, ventura:       "2b933216f2796ee8f9db0d423f12210eb318528e8b90bceb4e77f02ba07ea7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8c5f751a57baa07bd482644ca693ebb1b44847cc39f6bbe10c4e7ff6dbc54a7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/ni"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ni --version")

    (testpath/"package.json").write <<~EOS
      {
        "name": "test",
        "version": "1.0.0"
      }
    EOS

    output = pipe_output("#{bin}/ni", "npm\n", 0)
    assert_match "found 0 vulnerabilities", output
    assert_path_exists testpath/"package-lock.json"
  end
end
