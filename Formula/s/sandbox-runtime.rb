class SandboxRuntime < Formula
  desc "OS-level filesystem and network sandboxing for arbitrary commands"
  homepage "https://github.com/anthropics/sandbox-runtime"
  url "https://registry.npmjs.org/@anthropic-ai/sandbox-runtime/-/sandbox-runtime-0.0.83.tgz"
  sha256 "1be860bd2617d21bf67585dd10f92f781b2af5f5f27299f49badf63fe9848c85"
  license "Apache-2.0"
  head "https://github.com/anthropics/sandbox-runtime.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bf815364d30299001cdbfff53827b8da6943fe86a1b4ca7737ed4d5ff87781e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bf815364d30299001cdbfff53827b8da6943fe86a1b4ca7737ed4d5ff87781e"
    sha256 cellar: :any,                 arm64_linux:   "25f9e07bd7e4c064d5e6133d3634d5e08d1ed044da8cedc47571c73e8fddc04f"
    sha256 cellar: :any,                 x86_64_linux:  "3b82ba6c1d7c78472441b10d062a21a64008b5b55744c754fce3548643543bf6"
  end

  depends_on "openjdk" => :build
  depends_on "node"
  depends_on "ripgrep"

  on_linux do
    depends_on "bubblewrap"
    depends_on "libseccomp"
    depends_on "socat"
  end

  resource "helper-sources" do
    url "https://github.com/anthropics/sandbox-runtime/archive/refs/tags/v0.0.81.tar.gz"
    sha256 "36cd4426995b660482a70ae70a61ad32a9ce5965fc81dc59c817916bee0e58f3"
  end

  deny_network_access!

  def prepare_package_json
    package_json = JSON.parse((buildpath/"package.json").read)
    package_json.delete("devDependencies")
    # MXC is only used by the Windows sandbox backend.
    package_json.fetch("optionalDependencies").delete("@microsoft/mxc-sdk")
    (buildpath/"package.json").atomic_write(JSON.pretty_generate(package_json))
  end

  def fetch
    prepare_package_json
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    prepare_package_json
    rm_r buildpath/"npm-fetch" if (buildpath/"npm-fetch").exist?
    rm_r "vendor/srt-win"
    %w[arm64 x64].each { |arch| rm_r "vendor/seccomp/#{arch}" }
    rm "vendor/java-proxy-agent/srt-proxy-agent.jar"

    resource("helper-sources").stage do
      cp "vendor/build-common.ts", buildpath/"vendor"
      cp_r "vendor/java-proxy-agent-src", buildpath/"vendor"
      cp_r "vendor/seccomp-src", buildpath/"vendor" if OS.linux?
    end
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")
    inreplace "vendor/java-proxy-agent/build.ts", "../build-common.js", "../build-common.ts"
    system "node", "vendor/java-proxy-agent/build.ts"

    if OS.linux?
      inreplace "vendor/seccomp/build.ts" do |s|
        s.gsub! "../build-common.js", "../build-common.ts"
        # Homebrew supplies libseccomp and the C runtime through shared libraries.
        s.gsub! "'-static', ", ""
      end
      system "node", "vendor/seccomp/build.ts"
    end

    system "npm", "install", "--offline", *std_npm_args
    paths = [formula_opt_bin("ripgrep")]
    paths += [formula_opt_bin("socat"), formula_opt_bin("bubblewrap")] if OS.linux?
    # Prefer a host bubblewrap carrying distro-specific AppArmor configuration.
    (bin/"srt").write_env_script libexec/"bin/srt", PATH: "$PATH:#{paths.join(":")}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/srt --version")

    (testpath/"invalid.json").write <<~JSON
      {
        "network": { "allowedDomains": "not-an-array", "deniedDomains": [] },
        "filesystem": { "denyRead": [], "allowWrite": [], "denyWrite": [] }
      }
    JSON
    output = shell_output("#{bin}/srt --settings #{testpath}/invalid.json -c true 2>&1", 1)
    assert_match "does not hold a valid config", output
    assert_match "Refusing to run with the built-in defaults", output
    vendor = libexec/"lib/node_modules/@anthropic-ai/sandbox-runtime/vendor"
    assert_path_exists vendor/"java-proxy-agent/srt-proxy-agent.jar"
    if OS.linux?
      arch = Hardware::CPU.intel? ? "x64" : "arm64"
      assert_path_exists vendor/"seccomp/#{arch}/apply-seccomp"
    end
  end
end
