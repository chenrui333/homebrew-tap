class Ni < Formula
  desc "Use the right package manager"
  homepage "https://github.com/sindresorhus/ni"
  url "https://registry.npmjs.org/@antfu/ni/-/ni-24.3.0.tgz"
  sha256 "5a076b98f91dde1ec211ee5c151994f45e315c2dc4eca37636a8cdbf4195b881"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66f1b7f0b8cfe919700735f3d45816b99281fb1c170a6d809c8cf86c19d82141"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7d83280b96642504ed8e2fb1025c0ce8fef168b6a798f9d1824df24c931bf4f"
    sha256 cellar: :any_skip_relocation, ventura:       "836b6c103a17980ae5f32422f5d383f460ebf8ae21208dda9fe2824bb2a313f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "904f14dbae5bf430699c5d016a3ee7f7be98597ffa77a3ea73225b68efd548e9"
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
