class Netperf < Formula
  desc "Benchmarks performance of many different types of networking"
  homepage "https://hewlettpackard.github.io/netperf/"
  license :cannot_represent

  head "https://github.com/HewlettPackard/netperf.git", branch: "master"

  stable do
    url "https://github.com/HewlettPackard/netperf/archive/refs/tags/netperf-2.7.0.tar.gz"
    sha256 "4569bafa4cca3d548eb96a486755af40bd9ceb6ab7c6abd81cc6aa4875007c4e"

    # only needed for AUTHORS changes of the following patch
    patch do
      url "https://github.com/HewlettPackard/netperf/commit/328fe3b56a8753f6f700aac2b2df84dda5ce93a3.patch?full_index=1"
      sha256 "e9696cb3dfccb73a595127c281ab0dd820eb8b84a440c96ab2c393444654daed"
    end

    patch do
      url "https://github.com/HewlettPackard/netperf/commit/0b0cbbef75021134c83be0c3dd21878467e11144.patch?full_index=1"
      sha256 "7dc26cd94228135f4f623a761bfd30e0e37076bf79d9a2e896ca63a5b56969cc"
    end

    # only needed for AUTHORS changes of the following patch
    patch do
      url "https://github.com/HewlettPackard/netperf/commit/ebc567aaad9b5d5808808c7d7aa78e80bb497e72.patch?full_index=1"
      sha256 "c16c4760e9b558fa3dfba95eabccabae5ee7775c610b917ad8c4d1d799119029"
    end

    patch do
      url "https://github.com/HewlettPackard/netperf/commit/40c8a0fb873ac07a95f0c0253b2bd66109aa4c51.patch?full_index=1"
      sha256 "072b24f7747d9e789422f0249be1023ee437628a8b5f56c3e27a5359daf55a92"
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc37cfb670784d93508bbbd80f4bea3bb8b1bb95d453f7224e613037ddcf0665"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3265fd05f2dee8d9bbeb348c4e69d35edd7a29e68310756b683bc185acae2a95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1643baed75d80b83d4477208e91f133c1399e74a4df6c5806ad7a3cdfa49b6fb"
    sha256 cellar: :any_skip_relocation, sequoia:       "8d88f8275d3c14369fa3a0dd973b1c9c848102895bafb42ba70092f5fdb90ae4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c16a10bb4f655c32943bfbbc234321481e721a0c59d15831b491985fc6308db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2e0695967d2c68c7b6b0f24df361201f5836ce5352066e8f0e98573a1f018d4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # Legacy K&R declarations fail with Clang's C23 default.
    ENV.append_to_cflags "-std=gnu17"

    # Work around failure from GCC 10+ using default of `-fno-common`
    # (resolves "multiple definition of `...'" errors)
    ENV.append_to_cflags "-fcommon" if OS.linux?

    # https://github.com/HewlettPackard/netperf/pull/67
    inreplace "src/netcpu_osx.c", "/* #include <mach/mach_port.h> */", "#include <mach/mach_port.h>"
    inreplace "src/netcpu_osx.c", "mach_port_deallocate(lib_host_port)",
      "mach_port_deallocate(mach_task_self(), lib_host_port)"

    rm %w[config.guess config.sub]
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage: netperf", shell_output("#{bin}/netperf -h 2>&1", 1)
  end
end
