class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://github.com/clidey/dory"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-1.9.0.tgz"
  sha256 "31be9dd5ca3bb445d4a81ee79e4522a45ecac2d599253ec64460f403705b67e2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b06d4b46c3e3051e544750dc31d4a4a8b3ead1081ffa133d608e6174d8091f98"
    sha256 cellar: :any,                 arm64_sequoia: "b06d4b46c3e3051e544750dc31d4a4a8b3ead1081ffa133d608e6174d8091f98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c159bd3340febf696849d5361e8b2d5977d7e4e9cc28597641ab9fa39918b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b422820b894161e9ddc36c7c0c95dd1938371eabc495460c24c6b31cb559a235"
  end

  depends_on "node"

  deny_network_access!

  def prepare_package_json
    # Use the source-built JavaScript implementation instead of sass-embedded's prebuilt Dart binary.
    package_json = JSON.parse((buildpath/"package.json").read)
    dependencies = package_json.fetch("dependencies")
    dependencies["sass"] = dependencies.delete("sass-embedded") if dependencies.key?("sass-embedded")
    (buildpath/"package.json").atomic_write(JSON.pretty_generate(package_json))
  end

  def fetch
    prepare_package_json
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    prepare_package_json
    # Keep Vite's workspace caches out of the read-only installation.
    # Upstream issue: https://github.com/clidey/dory/issues/163
    inreplace "bin/dist/dory.js", <<-OLD, <<-NEW
        symlinkSync(findDependencyDir(doryRoot), resolve(workspace, 'node_modules'), 'dir');
    OLD
        const dependencyDir = findDependencyDir(doryRoot);
        const workspaceModules = resolve(workspace, 'node_modules');
        mkdirSync(workspaceModules);
        for (const entry of readdirSync(dependencyDir)) {
            if (entry === '.vite' || entry === '.vite-temp') continue;
            symlinkSync(resolve(dependencyDir, entry), resolve(workspaceModules, entry));
        }
    NEW
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"dory", "init"
    assert_path_exists testpath/"dory.json"
    assert_match "Documentation ready in", shell_output("#{bin}/dory build 2>&1")
    assert_match "Start writing your documentation here.", (testpath/"dist/introduction/index.html").read
  end
end
