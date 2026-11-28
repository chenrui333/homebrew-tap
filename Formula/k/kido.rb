class Kido < Formula
  desc "Run macOS command-line tools in small Darwin virtual machines"
  homepage "https://kido.sh/"
  url "https://github.com/kido-sh/kido/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "311b55c85d64f29506b8d1bae24b2620ca1211d8ef9941cb47e86ce4235c1991"
  license "Apache-2.0"
  head "https://github.com/kido-sh/kido.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "301c1d089c231e2b3e4dc51ea77bc4561cc1a826f8110176b6b309c00e45724b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "79d0ce0fc6622b0d2cf2cde1ac25acc4d38beeb9a4175066ef9c5b3c9cfcff33"
    sha256 cellar: :any,                 arm64_linux: "966d1e8dc12832301d473d2be7111b3f161d50d342ac9e89c2b02c6044ebbca5"
  end

  depends_on "go" => :build
  depends_on arch: :arm64

  on_macos do
    # The VMM uses the vmnet network APIs introduced in the macOS 26 SDK.
    depends_on macos: :tahoe
  end

  on_linux do
    depends_on "rust" => :build
    depends_on "vulkan-headers" => :build
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "vmm-linux/Cargo.toml" if OS.linux?
  end

  def install
    if OS.mac?
      # The upstream sign target applies the Virtualization.framework entitlement.
      system "make", "sign", "VERSION=#{version}"
      (libexec/"kido").install "bin/kido-vmm"
    else
      system "make", "bin/kido", "bin/kido-agent", "VERSION=#{version}"
      # Build the VMM for Homebrew's native GNU/Linux target rather than upstream's portable musl target.
      system "cargo", "install", *std_cargo_args(path: "vmm-linux", root: buildpath/"vmm-install")
      system "make", "-C", "vmm-linux/kido-probe"
      (libexec/"kido").install "vmm-install/bin/kido-vmm", "vmm-linux/kido-probe/kido-probe"
    end

    bin.install "bin/kido"
    (libexec/"kido").install "bin/kido-agent"
    generate_completions_from_executable(bin/"kido", "completion")
  end

  def caveats
    <<~EOS
      Run `kido setup` to download the guest image before starting a VM.
      On Linux, the native backend requires access to /dev/kvm.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kido --version")

    ENV["KIDO_HOME"] = testpath/"kido"
    # Exercise the local image store without downloading or booting a guest.
    %w[disk.img kernel initrd.cpio].each { |name| (testpath/name).write("fixture\n") }
    uuid = "11111111-1111-4111-8111-111111111111"
    system bin/"kido", "image", "import", "--uuid", uuid, testpath, "brew-test:latest"
    output = shell_output("#{bin}/kido images brew-test:latest")
    assert_match(/REPOSITORY\s+TAG\s+IMAGE ID/, output)
    assert_match(/^brew-test\s+latest\s+[0-9a-f]{12}\b/, output)

    assert_path_exists libexec/"kido/kido-agent"
    vmm = libexec/"kido/kido-vmm"
    assert_predicate vmm, :executable?
    if OS.mac?
      system "codesign", "--verify", "--strict", vmm
      output = shell_output("codesign --display --entitlements - #{vmm} 2>/dev/null")
      assert_match "com.apple.security.virtualization", output
    else
      assert_predicate libexec/"kido/kido-probe", :executable?
    end
  end
end
