class Zigscient < Formula
  desc "Zig Language Server"
  homepage "https://github.com/llogick/zigscient"
  url "https://github.com/llogick/zigscient/archive/refs/tags/0.14.1.tar.gz"
  sha256 "b5cd9b64f768aa50ae6168c997b2b72c1830f644199b0a95f803db96be739e15"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66ea5f9271f2e5e196936b47557e45ef687a7a42257b0cecb0366732d3d49abc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eb58eb49a3992f0fce52657f01ba7808fc53199690228efadceb88702ac2860"
    sha256 cellar: :any_skip_relocation, ventura:       "14961fef3b718a7cf53c7ab0e954d3bd2a700bad60086354cdda78129b9422d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eca1a4d3501bdc026833e1fcf319f1ad83b205c0dd4c4afb013e8e2d3914444b"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zls --version")
    zis_version = Formula["zig"].version.to_s
    assert_match zis_version, shell_output("#{bin}/zls --compiler-version")

    output = shell_output("#{bin}/zls --show-config-path 2>&1")
    assert_match "No config file zls.json found", output
  end
end
