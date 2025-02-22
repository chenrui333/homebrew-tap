class Ni < Formula
  desc "Use the right package manager"
  homepage "https://github.com/sindresorhus/ni"
  url "https://registry.npmjs.org/@antfu/ni/-/ni-23.3.1.tgz"
  sha256 "90b7dfb524cfa3c3400cc0c6870a4ce16000e74ed279b5de2a10050444565a9b"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/ni"
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/ni --version").chomp
      @antfu/ni  v#{version}
      node       v#{Formula["node"].version}

      agent      no lock file
      npm -g     v10.9.2
    EOS

    (testpath/"package.json").write <<~EOS
      {
        "name": "test",
        "version": "1.0.0"
      }
    EOS

    output = pipe_output("#{bin}/ni", "npm\n", 0)
    assert_match "Choose the agent › npm", output
    assert_path_exists testpath/"package-lock.json"
  end
end
