class Jjfx < Formula
  desc "Terminal interface for Jujutsu workspaces"
  homepage "https://github.com/Jarvvski/jjfx"
  url "https://github.com/Jarvvski/jjfx/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "226da796cffa73820edbe92900fe76cbfdb9f658c239c6242840c4a9a08ef5ca"
  license "GPL-3.0-or-later"
  head "https://github.com/Jarvvski/jjfx.git", branch: "main"

  depends_on "rust" => :build
  depends_on "jj"

  # Match the library reading Jujutsu's store to the current command-line release.
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    # Upstream requires a repository even when generating shell completions.
    mkdir "completions" do
      system formula_opt_bin("jj")/"jj", "--config", "signing.behavior=drop", "git", "init", "--no-colocate"
      generate_completions_from_executable(bin/"jjfx", "completion", shells: [:zsh])
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjfx --version")

    (testpath/"jj.toml").write <<~TOML
      user.name = "Homebrew"
      user.email = "brew-test@localhost"
      signing.behavior = "drop"
    TOML
    ENV["JJ_CONFIG"] = (testpath/"jj.toml").to_s

    jj = formula_opt_bin("jj")/"jj"
    mkdir "repository" do
      system jj, "git", "init", "--no-colocate"
      system jj, "workspace", "add", "--name", "secondary", "--no-colocate", testpath/"secondary"
      output = shell_output("#{bin}/jjfx list")
      assert_match "default", output
      assert_match "secondary", output

      (Pathname.pwd/".jjfx/config.toml").write <<~TOML
        [pools.homebrew]
        size = 1
      TOML
      status = JSON.parse(shell_output("#{bin}/jjfx status --json 2>&1"))
      assert_empty status.fetch("workers")
      assert_empty status.fetch("waiting")
      pool = status.fetch("pools").find { |entry| entry.fetch("name") == "homebrew" }
      assert_equal 1, pool.fetch("size")
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -24,15 +24,6 @@
 checksum = "683d7910e743518b0e34f1186f92494becacb047c7b6bf616c96772180fef923"
 
 [[package]]
-name = "android_system_properties"
-version = "0.1.5"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "819e7219dbd41043ac279b19830f2efc897156490d7fd6ea916720117ee66311"
-dependencies = [
- "libc",
-]
-
-[[package]]
 name = "anyhow"
 version = "1.0.103"
 source = "registry+https://github.com/rust-lang/crates.io-index"
@@ -151,12 +142,6 @@
 ]
 
 [[package]]
-name = "bumpalo"
-version = "3.20.3"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "72f5acc6cb2ba439de613abc23857ec3d78374d8ed5ac84e9d11336e87da8649"
-
-[[package]]
 name = "byteorder"
 version = "1.5.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
@@ -184,16 +169,6 @@
 ]
 
 [[package]]
-name = "cc"
-version = "1.2.66"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f5d6cac793997bd970000024b2934968efe83b382de4fdcf4fcb46b6ee4ad996"
-dependencies = [
- "find-msvc-tools",
- "shlex",
-]
-
-[[package]]
 name = "cfg-if"
 version = "1.0.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
@@ -211,18 +186,6 @@
 ]
 
 [[package]]
-name = "chrono"
-version = "0.4.45"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1aa79e62e7697b8e29b513a68abacf485adcd1fe8284a4316c5ae868e6633327"
-dependencies = [
- "iana-time-zone",
- "num-traits",
- "serde",
- "windows-link",
-]
-
-[[package]]
 name = "clru"
 version = "0.6.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
@@ -275,12 +238,6 @@
 ]
 
 [[package]]
-name = "core-foundation-sys"
-version = "0.8.7"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "773648b94d0e5d620f64f280777445740e61fe701025087ec8b57f45c791888b"
-
-[[package]]
 name = "cpufeatures"
 version = "0.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
@@ -606,12 +563,6 @@
 ]
 
 [[package]]
-name = "find-msvc-tools"
-version = "0.1.9"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5baebc0774151f905a1a2cc41989300b1e6fbb29aff0ceffa1064fdd3088d582"
-
-[[package]]
 name = "flate2"
 version = "1.1.9"
 source = "registry+https://github.com/rust-lang/crates.io-index"
@@ -750,9 +701,9 @@
 
 [[package]]
 name = "gix"
-version = "0.88.0"
+version = "0.90.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "32d6dd6028308ad2f2662207506e396b97f9ec899f74bd537c0775248c774f21"
+checksum = "b92b20c1560511a9014b16e29db2f3c6f0580d4fe289b70f41131277b065a3b0"
 dependencies = [
  "gix-actor",
  "gix-attributes",
@@ -763,7 +714,6 @@
  "gix-diff",
  "gix-discover",
  "gix-error",
- "gix-features",
  "gix-filter",
  "gix-fs",
  "gix-glob",
@@ -776,6 +726,7 @@
  "gix-object",
  "gix-odb",
  "gix-pack",
+ "gix-parallel",
  "gix-path",
  "gix-pathspec",
  "gix-protocol",
@@ -802,9 +753,9 @@
 
 [[package]]
 name = "gix-actor"
-version = "0.43.0"
+version = "0.44.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8e046e9a929e8e1f40f9a34f736408c4c079f9cf004429f3e718d270e847be96"
+checksum = "78243d3371019288a40a75ba1a58de2815c32591fc87b9f7cb01918bce364ca8"
 dependencies = [
  "bstr",
  "gix-date",
@@ -813,14 +764,14 @@
 
 [[package]]
 name = "gix-attributes"
-version = "0.36.0"
+version = "0.37.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a3d57bcf18768dc259868e335fae99a9063174178b78b00348603f0791cd780a"
+checksum = "6b9947d93a94d41ddde66ac655674269121cbebaf6cdee30d8d0e7dbe85edb4c"
 dependencies = [
  "bstr",
  "gix-error",
- "gix-features",
  "gix-glob",
+ "gix-parallel",
  "gix-path",
  "gix-quote",
  "gix-trace",
@@ -830,27 +781,27 @@
 
 [[package]]
 name = "gix-bitmap"
-version = "0.5.0"
+version = "0.6.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4e9d28a8333a322df5c4fdc7b86a9928965e50794523c0edff57d1fbf2a520cf"
+checksum = "422cd23418fd80e9e965595323975d72abd6364a66ff8f0daade5c105a7f35d2"
 dependencies = [
  "gix-error",
 ]
 
 [[package]]
 name = "gix-chunk"
-version = "0.9.0"
+version = "0.10.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "25303d07ce2b8f98aab48ce4251317d785a3208b7ed65698928e4a2f31889936"
+checksum = "dc6a775aba54f0d65698126cc4214b6bf8ddb208312e4ef4240dfe34b0697b87"
 dependencies = [
  "gix-error",
 ]
 
 [[package]]
 name = "gix-command"
-version = "0.11.0"
+version = "0.12.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "eb3c2e61f97adc08764060e9becb0c819d8f2ba27896434710e039ae57b1d2a7"
+checksum = "df63215f103299169e239dfe76f5cfa4a3d6d4adf69a01774085e3e0423cba34"
 dependencies = [
  "bstr",
  "gix-error",
@@ -861,9 +812,9 @@
 
 [[package]]
 name = "gix-commitgraph"
-version = "0.40.0"
+version = "0.42.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0462cbffd5828447f376559d397d9b29f1979dac3d980b5212b17fa174b174eb"
+checksum = "60b53b700d2a506cf98075099df1fcc0558265cbb47fd86bc6d03c231e4bd72a"
 dependencies = [
  "bstr",
  "gix-chunk",
@@ -875,18 +826,19 @@
 
 [[package]]
 name = "gix-config"
-version = "0.61.0"
+version = "0.62.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "eb2cb454dce2f1895cf9def1df8b0a6bbc579d86d8313bdf60f1ab429d52df12"
+checksum = "3e11ccf82e9630c4e7befbae07cbe90e79de61dc73a34448c2dec70a13da9ebf"
 dependencies = [
  "bstr",
  "gix-config-value",
  "gix-error",
- "gix-features",
  "gix-glob",
+ "gix-parallel",
  "gix-path",
  "gix-ref",
  "gix-sec",
+ "gix-trace",
  "gix-utils",
  "smallvec",
  "unicode-bom",
@@ -894,22 +846,23 @@
 
 [[package]]
 name = "gix-config-value"
-version = "0.20.0"
+version = "0.21.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1894e816c774650b5157d965853b50d7e8f7137ea74055a6bac2f2ec051cf997"
+checksum = "6cdada8bd9c97dc6522505c08226d9c88f0a1286f2c06b9e1bf51c3bf7ad7b2b"
 dependencies = [
  "bitflags 2.13.0",
  "bstr",
  "gix-error",
  "gix-path",
+ "gix-utils",
  "libc",
 ]
 
 [[package]]
 name = "gix-date"
-version = "0.17.0"
+version = "0.18.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "cb8beceb16a77fb222923592864b94beb4ad4c2b175a7055c2cac6815ee0370a"
+checksum = "4c538190012dbb536df54734ec38cc1109270c73f2f76585c011dd5b0c9f087c"
 dependencies = [
  "bstr",
  "gix-error",
@@ -919,9 +872,9 @@
 
 [[package]]
 name = "gix-diff"
-version = "0.68.0"
+version = "0.70.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "939aee7bbc9f233de858839e865c82886e0baceb8f1fe792ea1703fa895f09e1"
+checksum = "2c794988335792f85c3ca79c385c950b3a921a71ba3df361cb1f9e5b6bd4a6e4"
 dependencies = [
  "bstr",
  "gix-command",
@@ -940,9 +893,9 @@
 
 [[package]]
 name = "gix-discover"
-version = "0.56.0"
+version = "0.57.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4476ba055ec5fbb05f59dd98380b596428da060beac5f9dccd7374302ad1fbfb"
+checksum = "4a0875f4e5408713fcf92265973cc38bf9dc5a93384ce218beba0572b7785a03"
 dependencies = [
  "bstr",
  "dunce",
@@ -955,37 +908,18 @@
 
 [[package]]
 name = "gix-error"
-version = "0.4.0"
+version = "0.5.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2c4a5c4cd326ddfe7f046ad9eed05461c59af6ea98b681648bac73954317addd"
+checksum = "d87ff4b3f3daf01234d38d176b0ec00e92de514cc0e3fb8a8898c5cb7ccd22bb"
 dependencies = [
  "bstr",
 ]
 
 [[package]]
-name = "gix-features"
-version = "0.50.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bb3a430dbc02d6c5e30a9f92083459593495ea22a476e837d248b22d800eed80"
-dependencies = [
- "bytes",
- "crc32fast",
- "crossbeam-channel",
- "gix-path",
- "gix-trace",
- "gix-utils",
- "libc",
- "once_cell",
- "parking_lot",
- "prodash",
- "walkdir",
-]
-
-[[package]]
 name = "gix-filter"
-version = "0.35.0"
+version = "0.36.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6f31a39e2c9b04843709d1f72b2c39c98dc0ee591e2f67d21302dbfbd06d2956"
+checksum = "f8df8d50fda4684c6ec366f75e4082ab6fc3d437d3deec30ff88462710b68d17"
 dependencies = [
  "bstr",
  "encoding_rs",
@@ -1004,48 +938,51 @@
 
 [[package]]
 name = "gix-fs"
-version = "0.23.0"
+version = "0.24.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0105ab1cef4542d092c27766d2daf1548fcbad7e460dc2208642c120bb19b3ad"
+checksum = "808f23d897ddfe847d9b7206bda947901885be623bdf96b226a2dccf87f018c7"
 dependencies = [
  "bstr",
  "gix-error",
- "gix-features",
+ "gix-parallel",
  "gix-path",
  "gix-utils",
+ "libc",
+ "walkdir",
 ]
 
 [[package]]
 name = "gix-glob"
-version = "0.28.0"
+version = "0.29.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bba50803dea16646cafb9a2d67e95b8cdf5b21c7e8c45bcd18f38bafe02fb81f"
+checksum = "7a12789fa68a150293ad8834d267b31044240532b5ccf2734d228fe985cba2be"
 dependencies = [
  "bitflags 2.13.0",
  "bstr",
- "gix-features",
+ "gix-fs",
  "gix-path",
+ "gix-trace",
  "gix-utils",
 ]
 
 [[package]]
 name = "gix-hash"
-version = "0.27.0"
+version = "0.28.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7a22b6febaaee8546eb0c9dd21ecdd93aca269a6cb3897e1250f0f60933c0174"
+checksum = "b4802ffb87e051795822bfdaa8ab9075b23e316684f7054e6ce4a246b2b76f4e"
 dependencies = [
  "faster-hex",
  "gix-error",
- "gix-features",
+ "gix-utils",
  "sha1dc",
  "sha2",
 ]
 
 [[package]]
 name = "gix-hashtable"
-version = "0.17.0"
+version = "0.18.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c55bff2f32f6f5a95bdd43e5e5e01b0656250cffbc48eda19db0afa3d73adf2f"
+checksum = "2f66822aee11ccb28d6a2e63b587254e578fb52a138bd5806b58d8560125592b"
 dependencies = [
  "gix-hash",
  "hashbrown 0.17.1",
@@ -1054,9 +991,9 @@
 
 [[package]]
 name = "gix-ignore"
-version = "0.23.0"
+version = "0.24.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5bfd910e271ecd1a20e4df4009a0d9d844a0c51ee5444aaa3fadd1b1b077930b"
+checksum = "968f12fe42896873504f46127cd5bf0f9a34fc1479a781f43cf94b5d8d760a15"
 dependencies = [
  "bstr",
  "gix-glob",
@@ -1067,9 +1004,9 @@
 
 [[package]]
 name = "gix-imara-diff"
-version = "0.3.1"
+version = "0.3.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1c48eccd894bd15555b0346470e63491ded94aefe76b3fcb1052084b5a393238"
+checksum = "7518b930f6aeb75e871d32ce873c2ae46e35cef19b5a0b039d4337f651d897cd"
 dependencies = [
  "bstr",
  "hashbrown 0.17.1",
@@ -1077,9 +1014,9 @@
 
 [[package]]
 name = "gix-index"
-version = "0.56.0"
+version = "0.58.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "dfd5b484b5b4e218a5ac114f0982949f9bd7582ff67986665a0cf85895332433"
+checksum = "06bfc736774a623307eda890c918d308ef5acd37402bde2d6768fccb1f6ecb5d"
 dependencies = [
  "bitflags 2.13.0",
  "bstr",
@@ -1087,11 +1024,12 @@
  "fnv",
  "gix-bitmap",
  "gix-error",
- "gix-features",
  "gix-fs",
  "gix-hash",
  "gix-lock",
  "gix-object",
+ "gix-parallel",
+ "gix-trace",
  "gix-traverse",
  "gix-utils",
  "gix-validate",
@@ -1105,11 +1043,12 @@
 
 [[package]]
 name = "gix-lock"
-version = "25.0.0"
+version = "26.0.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8fd5ddfd0cc476fef744ac544783b96a9ff5d49f8de541e6e9d6d6002aa90720"
+checksum = "64783de116c477c5ea4a7f3b56e18ab363dabfdae2724291ea0587b642cadb3d"
 dependencies = [
  "gix-error",
+ "gix-fs",
  "gix-tempfile",
  "gix-utils",
 ]
@@ -1127,9 +1066,9 @@
 
 [[package]]
 name = "gix-note"
-version = "0.2.0"
+version = "0.3.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5d6879cc9e5a9a0429e40b05970af6c8dad8734098a3142fec23e32eeb567580"
+checksum = "8473688f2262f4364f521b39ce2a5dbe94494f327fc19c945318d7aff580952e"
 dependencies = [
  "gix-error",
  "gix-hash",
@@ -1138,16 +1077,15 @@
 
 [[package]]
 name = "gix-object"
-version = "0.65.0"
+version = "0.66.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a72909eeeed845721a143ef3dbeb4d6cd5df79c839fe7eefc138cb4f982eba3e"
+checksum = "beaf9086dd00b9d2a177ca3ae83210ce926cee7c0faa112e053851221cd8f94d"
 dependencies = [
  "bstr",
  "gix-actor",
  "gix-command",
  "gix-date",
  "gix-error",
- "gix-features",
  "gix-hash",
  "gix-hashtable",
  "gix-path",
@@ -1160,20 +1098,23 @@
 
 [[package]]
 name = "gix-odb"
-version = "0.85.0"
+version = "0.87.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5794b85ff563a290ea18867fa1f0a5b0b84709f2f34dddbb3614556fbe88c629"
+checksum = "941b5b99fed282a5b05b54ea486c36c76b558afe151e6804c3acdd5c8f3c3459"
 dependencies = [
  "arc-swap",
+ "crc32fast",
  "gix-error",
- "gix-features",
  "gix-fs",
  "gix-hash",
  "gix-hashtable",
  "gix-object",
  "gix-pack",
+ "gix-parallel",
  "gix-path",
  "gix-quote",
+ "gix-trace",
+ "gix-utils",
  "gix-zlib",
  "memmap2",
  "parking_lot",
@@ -1182,19 +1123,22 @@
 
 [[package]]
 name = "gix-pack"
-version = "0.75.0"
+version = "0.77.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0451a48faef8e0e7a8f6d903c8329c7d18a793b3030907ca841f889dc695d1df"
+checksum = "e2ef461798b1e6cb652192c69dfc9658dfc1bab457ef812dd1ab85d75104cbef"
 dependencies = [
  "clru",
+ "crc32fast",
  "crossbeam-deque",
  "gix-chunk",
  "gix-error",
- "gix-features",
  "gix-hash",
  "gix-hashtable",
  "gix-object",
+ "gix-parallel",
  "gix-path",
+ "gix-trace",
+ "gix-utils",
  "gix-zlib",
  "memmap2",
  "smallvec",
@@ -1203,9 +1147,9 @@
 
 [[package]]
 name = "gix-packetline"
-version = "0.23.0"
+version = "0.24.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0ba540112a3fcc6388eb2aa4dc4837040478c285a35178cd9a44b07345cd6636"
+checksum = "8ebb59ef7aff9d435946a5e5c3d9cfb673be7665839fd72961c08c733a934fb7"
 dependencies = [
  "bstr",
  "faster-hex",
@@ -1214,10 +1158,22 @@
 ]
 
 [[package]]
+name = "gix-parallel"
+version = "0.50.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "58e7e10f8343e05f6ad8651f97dffa1caca1531bb274bfc8e3050e80e3ed5946"
+dependencies = [
+ "crossbeam-channel",
+ "gix-trace",
+ "once_cell",
+ "parking_lot",
+]
+
+[[package]]
 name = "gix-path"
-version = "0.13.0"
+version = "0.14.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fd051ac60c5dbce2228daabf25b6a76408ac732d416c678cfa0a4914d13f60b8"
+checksum = "83976e926a485e6fb4b8d9a0d7a30c53c1f607b81b5d310f06f92fd8385bf16a"
 dependencies = [
  "bstr",
  "gix-error",
@@ -1227,9 +1183,9 @@
 
 [[package]]
 name = "gix-pathspec"
-version = "0.21.0"
+version = "0.22.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1ee883ab64bad641bf31ff338044edd7aa010605f19e866d98c9164e635c38b1"
+checksum = "490aa03a11e0cbb998a0a593b75e27ea2e30df4ebd8f84f60e0641b9b72270e8"
 dependencies = [
  "bitflags 2.13.0",
  "bstr",
@@ -1242,14 +1198,13 @@
 
 [[package]]
 name = "gix-protocol"
-version = "0.66.0"
+version = "0.68.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "331ac489c461790b6b692afb322085c42041c6ff7621c30ac3dbb00b12e05e89"
+checksum = "83677ebae6a1a09dc07f2435b5ebe68470dc51afb74052135e98fd7c11f85ba9"
 dependencies = [
  "bstr",
  "gix-date",
  "gix-error",
- "gix-features",
  "gix-hash",
  "gix-macros",
  "gix-ref",
@@ -1261,9 +1216,9 @@
 
 [[package]]
 name = "gix-quote"
-version = "0.9.0"
+version = "0.10.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e6b040cfa7af50f131bfa34119cceee804c3cc40c766daaba8e0c8149340aea7"
+checksum = "2413e65271303e9b674ec4785d469df4c3c36e888dbd165e3035de0405c6d9d1"
 dependencies = [
  "bstr",
  "gix-error",
@@ -1272,17 +1227,17 @@
 
 [[package]]
 name = "gix-ref"
-version = "0.68.0"
+version = "0.69.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c90ceeec67de03b737c30b1b69116ca56fec803edde022f3d25181f0f597083d"
+checksum = "68686e4697b9cd15d1b152ef51df870513210ed22938eacc13b3672b76035f13"
 dependencies = [
  "gix-actor",
  "gix-error",
- "gix-features",
  "gix-fs",
  "gix-hash",
  "gix-lock",
  "gix-object",
+ "gix-parallel",
  "gix-path",
  "gix-tempfile",
  "gix-utils",
@@ -1292,9 +1247,9 @@
 
 [[package]]
 name = "gix-refspec"
-version = "0.46.0"
+version = "0.47.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b4caa89a034a055c0578150092d3edb2f1c3f74cca86b883263a28caa26c5812"
+checksum = "2569309da6fdc230973cf5b846508154c0e813fda60f2b2da768cc5655ed312c"
 dependencies = [
  "bstr",
  "gix-error",
@@ -1305,9 +1260,9 @@
 
 [[package]]
 name = "gix-revision"
-version = "0.50.0"
+version = "0.52.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d8438d38e197fa3ea7bb297302db1701879a64a343f23a3d150a602a609a8751"
+checksum = "241465fc73530f41d0a1c18320c5e291365b7c2c2a3dfd07afe2a5d6265085c8"
 dependencies = [
  "bstr",
  "gix-commitgraph",
@@ -1321,9 +1276,9 @@
 
 [[package]]
 name = "gix-revwalk"
-version = "0.36.0"
+version = "0.38.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2fa6d913e7cf8c6407d3954f9794b4b148c2113c672c34b63c59ea654a1e060e"
+checksum = "8b46edeacd25d9d3131941ae6bc91002bf7ba10e130393b7e9bc23d528625447"
 dependencies = [
  "gix-commitgraph",
  "gix-date",
@@ -1336,9 +1291,9 @@
 
 [[package]]
 name = "gix-sec"
-version = "0.15.0"
+version = "0.16.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7d8eb983a830ba586b61f7005deaf44609e1a4186cbf13a0e8668154ca910461"
+checksum = "9598d1f35baec7038c2d278bfcc18f1d8951f41dcc3f51ab6175661dfe5a6137"
 dependencies = [
  "bitflags 2.13.0",
  "gix-path",
@@ -1348,9 +1303,9 @@
 
 [[package]]
 name = "gix-shallow"
-version = "0.14.0"
+version = "0.15.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "119bae1301715df40e8fd136deeff4fe8a3be4cfc001ed5e72bad7b47ebbc090"
+checksum = "1d805949578724b5164c90ec6d19567832ccaa5ba8a3fe26f7befc52007e2407"
 dependencies = [
  "bstr",
  "gix-error",
@@ -1361,9 +1316,9 @@
 
 [[package]]
 name = "gix-submodule"
-version = "0.35.0"
+version = "0.36.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0b498192e5f89453fbd728263d52088aeec634a390e732f1da6d0a491c552091"
+checksum = "d558a1307b6f3de2a92bd91d0570c53952d4f2329e6860813007508c8ed413dc"
 dependencies = [
  "bstr",
  "gix-config",
@@ -1376,9 +1331,9 @@
 
 [[package]]
 name = "gix-tempfile"
-version = "25.0.0"
+version = "26.0.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3dd7dd8df3345933caddd6ce67821c9eec17192564f1011cf0bd0b8cb0d07ffb"
+checksum = "b8fdb135a043d6106b59bc58d59a326b277e495ec26fb9e02a1e2b6354bf4b5a"
 dependencies = [
  "dashmap",
  "gix-fs",
@@ -1390,32 +1345,33 @@
 
 [[package]]
 name = "gix-trace"
-version = "0.2.0"
+version = "0.3.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "df45b2cf6052d9e52681130c17d67505b023e8933ad974f94a2be0b0d24f636a"
+checksum = "c477c029518d3f235c26db21ff7cccc1fa13c0c31b05c005a55b7affd4ffbd81"
 
 [[package]]
 name = "gix-transport"
-version = "0.60.0"
+version = "0.62.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5d2beb7b0387bbf4d7c13763c6e168f9957319aa811f09349dc59601be3b2951"
+checksum = "cdcd9cdfd8745aa38f926a4a380c13d76b200d7338de57fc492982cd5a6652ba"
 dependencies = [
  "bstr",
  "gix-command",
  "gix-error",
- "gix-features",
  "gix-packetline",
  "gix-path",
  "gix-quote",
  "gix-sec",
+ "gix-trace",
  "gix-url",
+ "gix-utils",
 ]
 
 [[package]]
 name = "gix-traverse"
-version = "0.62.0"
+version = "0.64.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "dd4864934e4efd92082ecc37107bce0c389b58d82888db634817f9c711efb7ed"
+checksum = "00171e00e91508300d0361072c4eb110ec0f1322d8b95ed36887231702a38ebc"
 dependencies = [
  "bitflags 2.13.0",
  "gix-commitgraph",
@@ -1430,9 +1386,9 @@
 
 [[package]]
 name = "gix-url"
-version = "0.39.0"
+version = "0.40.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1f30fe2a228d7de5f9d582463d9b724debcb870162d9fbe908cd5d76ccdecf0d"
+checksum = "def12e1016b872f1094442882f627905c59bd73480435291a4958cf373a8f28d"
 dependencies = [
  "bstr",
  "gix-error",
@@ -1443,21 +1399,24 @@
 
 [[package]]
 name = "gix-utils"
-version = "0.4.0"
+version = "0.5.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "70525766f53426ca4cd2ea4d58b0b31488dfedb416b3254e2efdd9dc184cc880"
+checksum = "11a9446060447e9ec58f5d333b98bed53389dfa10de5d8dd46fc76d01dfc2954"
 dependencies = [
  "bstr",
+ "bytes",
  "fastrand",
  "getrandom",
+ "gix-error",
+ "prodash",
  "unicode-normalization",
 ]
 
 [[package]]
 name = "gix-validate"
-version = "0.12.0"
+version = "0.13.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "30574f81fc41b2ca3582ece2bdf8696bdfe9c170aa7e8bcafb81199c86b1ceea"
+checksum = "02b617c17754bf37ee7a9b48e33ffb806abecbbed779ba415199ac1480acf699"
 dependencies = [
  "bstr",
  "gix-error",
@@ -1465,14 +1424,13 @@
 
 [[package]]
 name = "gix-worktree"
-version = "0.57.0"
+version = "0.59.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "04fa19b9b3961aafb3b9e60005b9bcef0100f8b211f46ab5269a6ac896073780"
+checksum = "fe92aec0a25cf073394492a6ee2aa4d27632acde91a653d34de0e4da6afb485d"
 dependencies = [
  "bstr",
  "gix-attributes",
  "gix-error",
- "gix-features",
  "gix-fs",
  "gix-glob",
  "gix-hash",
@@ -1485,27 +1443,29 @@
 
 [[package]]
 name = "gix-worktree-stream"
-version = "0.37.0"
+version = "0.39.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2021e1609beae0edbeefa76ac641be0571b725afacb77ac5b12f33b436e0d3d9"
+checksum = "3fe5d65793848ffb596f6c5596fd120b132038736525628227e2388ca454f64d"
 dependencies = [
  "gix-attributes",
  "gix-error",
- "gix-features",
  "gix-filter",
  "gix-fs",
  "gix-hash",
  "gix-object",
+ "gix-parallel",
  "gix-path",
+ "gix-trace",
  "gix-traverse",
+ "gix-utils",
  "parking_lot",
 ]
 
 [[package]]
 name = "gix-zlib"
-version = "0.2.0"
+version = "0.4.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "44a1a9c82ec5b712082566cbef8f5782472a0d3973132911e5a83380a5298fe2"
+checksum = "7c5b29808570149d86f417184605111ede9dda5aa06015e9ea6da07f0c3ca41e"
 dependencies = [
  "gix-error",
  "zlib-rs",
@@ -1595,30 +1555,6 @@
 checksum = "27f864f10dfb56725ce5ce5472bc52252c8f93a4ab86327122cebf62c5f59a17"
 dependencies = [
  "typenum",
-]
-
-[[package]]
-name = "iana-time-zone"
-version = "0.1.65"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e31bc9ad994ba00e440a8aa5c9ef0ec67d5cb5e5cb0cc7f8b744a35b389cc470"
-dependencies = [
- "android_system_properties",
- "core-foundation-sys",
- "iana-time-zone-haiku",
- "js-sys",
- "log",
- "wasm-bindgen",
- "windows-core",
-]
-
-[[package]]
-name = "iana-time-zone-haiku"
-version = "0.1.2"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f31827a206f56af32e590ba56d5d2d085f558508192593743f16b2306495269f"
-dependencies = [
- "cc",
 ]
 
 [[package]]
@@ -1687,7 +1623,7 @@
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "a9ce9099a85f468663d3225bf87e85d0548968441e1db12248b996b24f0f5b5a"
 dependencies = [
- "chrono",
+ "jiff",
  "logos",
 ]
 
@@ -1768,14 +1704,13 @@
 
 [[package]]
 name = "jj-core"
-version = "0.46.0"
+version = "0.47.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6cc6c2549b3eeb6b87063e49786e3c73abea653d9b88b20c982967a8b112db40"
+checksum = "eba631c4b2a4cb0e7eca54e416eadfd1a61346eaaee96688e8fa6b1260facb57"
 dependencies = [
  "async-trait",
  "blake2",
  "bstr",
- "chrono",
  "clru",
  "digest",
  "either",
@@ -1783,24 +1718,24 @@
  "globset",
  "hashbrown 0.17.1",
  "indexmap",
+ "interim",
  "itertools 0.15.0",
+ "jiff",
  "jj-core-proc-macros",
+ "pollster 1.0.1",
  "ref-cast",
  "regex",
- "same-file",
  "serde",
  "smallvec",
- "tempfile",
  "thiserror",
  "tracing",
- "winreg",
 ]
 
 [[package]]
 name = "jj-core-proc-macros"
-version = "0.46.0"
+version = "0.47.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4936b0a5244527dd7e2370c3553920b402a7b44cfecf6748131dedaa1890bb81"
+checksum = "6ac4753be113180892863776c8420d8b53133009781a7891e142cde4933ae23c"
 dependencies = [
  "proc-macro2",
  "quote",
@@ -1808,16 +1743,76 @@
 ]
 
 [[package]]
-name = "jj-lib"
-version = "0.46.0"
+name = "jj-default-index"
+version = "0.47.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4b82d2d9b1f8400db1dda9a22bccfa6c3118f5592dfe6578452e56dcb378e9ad"
+checksum = "0477524efdd0f5a8959b3442129452309354360dadf3565e9482f592464e986d"
 dependencies = [
  "async-trait",
  "blake2",
  "bstr",
- "chrono",
- "clru",
+ "digest",
+ "either",
+ "futures",
+ "itertools 0.15.0",
+ "jj-core",
+ "jj-local-util",
+ "maplit",
+ "pollster 1.0.1",
+ "prost",
+ "ref-cast",
+ "smallvec",
+ "tempfile",
+ "thiserror",
+ "tracing",
+]
+
+[[package]]
+name = "jj-dsl"
+version = "0.47.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "45dd9b5fd81bcb594aafb87c89eec71d1405ce385143c943f29c6014922546c1"
+dependencies = [
+ "itertools 0.15.0",
+ "jj-core",
+ "pest",
+ "pest_derive",
+ "strsim",
+ "thiserror",
+]
+
+[[package]]
+name = "jj-git-backend"
+version = "0.47.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "a6144feaf22f59dd2c65333c34187a664634d545c216f0242c02a7cf688edd56"
+dependencies = [
+ "async-trait",
+ "blake2",
+ "dunce",
+ "futures",
+ "gix",
+ "itertools 0.15.0",
+ "jj-core",
+ "jj-local-util",
+ "once_cell",
+ "pollster 1.0.1",
+ "prost",
+ "smallvec",
+ "tempfile",
+ "thiserror",
+ "tracing",
+]
+
+[[package]]
+name = "jj-lib"
+version = "0.47.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "55cf027ca97220abebfc8c87613f69126730535836a3e8f3968bdf64b3022f17"
+dependencies = [
+ "async-trait",
+ "blake2",
+ "bstr",
  "digest",
  "dunce",
  "either",
@@ -1826,14 +1821,16 @@
  "gix-ignore",
  "globset",
  "indexmap",
- "interim",
  "itertools 0.15.0",
+ "jiff",
  "jj-core",
+ "jj-default-index",
+ "jj-dsl",
+ "jj-git-backend",
+ "jj-local-util",
  "maplit",
  "memchr",
  "once_cell",
- "pest",
- "pest_derive",
  "pollster 1.0.1",
  "prost",
  "rand",
@@ -1841,15 +1838,32 @@
  "rayon",
  "ref-cast",
  "regex",
- "rustix 1.1.4",
  "serde",
  "smallvec",
- "strsim",
  "tempfile",
  "thiserror",
  "toml_edit 0.25.12+spec-1.1.0",
  "tracing",
+]
+
+[[package]]
+name = "jj-local-util"
+version = "0.47.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "f1d32a882ff2453e9becbbca1dee041d8162240aaf020e11994a4ab88643c2e9"
+dependencies = [
+ "blake2",
+ "futures",
+ "itertools 0.15.0",
+ "jj-core",
+ "rand",
+ "rustix 1.1.4",
+ "same-file",
+ "tempfile",
+ "thiserror",
+ "tracing",
  "windows-sys 0.61.2",
+ "winreg",
 ]
 
 [[package]]
@@ -1878,17 +1892,6 @@
 ]
 
 [[package]]
-name = "js-sys"
-version = "0.3.103"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "53b44bfcdb3f8d5837a46dae1ca9660a837176eee74a28b229bc626816589102"
-dependencies = [
- "cfg-if",
- "futures-util",
- "wasm-bindgen",
-]
-
-[[package]]
 name = "kasuari"
 version = "0.4.12"
 source = "registry+https://github.com/rust-lang/crates.io-index"
@@ -2113,15 +2116,6 @@
 checksum = "521739c6d2bac4aa25192232afe6841231376b2b26d4d9fae5ecf8ca5772e441"
 
 [[package]]
-name = "num-traits"
-version = "0.2.19"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "071dfc062690e90b734c0b2273ce72ad0ffa95f0c74596bc250dcfd960262841"
-dependencies = [
- "autocfg",
-]
-
-[[package]]
 name = "once_cell"
 version = "1.21.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
@@ -2276,9 +2270,9 @@
 
 [[package]]
 name = "prodash"
-version = "31.0.0"
+version = "31.0.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "962200e2d7d551451297d9fdce85138374019ada198e30ea9ede38034e27604c"
+checksum = "cf52d87428247c5aa3760ac8e7d8b13ec7b3579b955a8c3f311668b6860acba5"
 dependencies = [
  "parking_lot",
 ]
@@ -2672,12 +2666,6 @@
  "cpufeatures",
  "digest",
 ]
-
-[[package]]
-name = "shlex"
-version = "2.0.1"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f8fadd59c855ef2080decdef8ff161eb6661b86933c9d82e5ba29dc602a55aba"
 
 [[package]]
 name = "signal-hook"
@@ -3142,53 +3130,8 @@
 version = "0.11.1+wasi-snapshot-preview1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "ccf3ec651a847eb01de73ccad15eb7d99f80485de043efb2f370cd654f4ea44b"
-
-[[package]]
-name = "wasm-bindgen"
-version = "0.2.126"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4b067c0c11094aef6b7a801c1e34a26affafdf3d051dba08456b868789aaf9a4"
-dependencies = [
- "cfg-if",
- "once_cell",
- "rustversion",
- "wasm-bindgen-macro",
- "wasm-bindgen-shared",
-]
-
-[[package]]
-name = "wasm-bindgen-macro"
-version = "0.2.126"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "167ce5e579f6bcf889c4f7175a8a5a585de84e8ff93976ce393efa5f2837aab1"
-dependencies = [
- "quote",
- "wasm-bindgen-macro-support",
-]
-
-[[package]]
-name = "wasm-bindgen-macro-support"
-version = "0.2.126"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f3997c7839262f4ef12cf90b818d6340c18e80f263f1a94bf157d0ec4420380e"
-dependencies = [
- "bumpalo",
- "proc-macro2",
- "quote",
- "syn 2.0.118",
- "wasm-bindgen-shared",
-]
 
 [[package]]
-name = "wasm-bindgen-shared"
-version = "0.2.126"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "dc1b4cb0cc549fcf58d7dfc081778139b3d283a081644e833e84682ad71cea24"
-dependencies = [
- "unicode-ident",
-]
-
-[[package]]
 name = "winapi"
 version = "0.3.9"
 source = "registry+https://github.com/rust-lang/crates.io-index"
@@ -3220,65 +3163,12 @@
 checksum = "712e227841d057c1ee1cd2fb22fa7e5a5461ae8e48fa2ca79ec42cfc1931183f"
 
 [[package]]
-name = "windows-core"
-version = "0.62.2"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b8e83a14d34d0623b51dce9581199302a221863196a1dde71a7663a4c2be9deb"
-dependencies = [
- "windows-implement",
- "windows-interface",
- "windows-link",
- "windows-result",
- "windows-strings",
-]
-
-[[package]]
-name = "windows-implement"
-version = "0.60.2"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "053e2e040ab57b9dc951b72c264860db7eb3b0200ba345b4e4c3b14f67855ddf"
-dependencies = [
- "proc-macro2",
- "quote",
- "syn 2.0.118",
-]
-
-[[package]]
-name = "windows-interface"
-version = "0.59.3"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3f316c4a2570ba26bbec722032c4099d8c8bc095efccdc15688708623367e358"
-dependencies = [
- "proc-macro2",
- "quote",
- "syn 2.0.118",
-]
-
-[[package]]
 name = "windows-link"
 version = "0.2.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "f0805222e57f7521d6a62e36fa9163bc891acd422f971defe97d64e70d0a4fe5"
 
 [[package]]
-name = "windows-result"
-version = "0.4.1"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7781fa89eaf60850ac3d2da7af8e5242a5ea78d1a11c49bf2910bb5a73853eb5"
-dependencies = [
- "windows-link",
-]
-
-[[package]]
-name = "windows-strings"
-version = "0.5.1"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7837d08f69c77cf6b07689544538e017c1bfcf57e34b4c0ff58e6c2cd3b37091"
-dependencies = [
- "windows-link",
-]
-
-[[package]]
 name = "windows-sys"
 version = "0.59.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
diff --git a/Cargo.toml b/Cargo.toml
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -66,12 +66,12 @@
 ratatui-textarea = "0.8"
 notify = "8"
 # jj-lib reads the on-disk .jj store directly for the commit graph (ADR 0007),
-# so its version must equal the `jj` mise pin (0.46.0) and upgrade in lockstep.
+# so its version must equal the installed `jj` (0.47.1) and upgrade in lockstep.
 # pollster block_on's jj-lib's async RepoLoader inside spawn_blocking (spike 02).
-jj-lib = "0.46.0"
+jj-lib = "0.47.1"
 pollster = "0.4"
 # The DAG column/edge renderer jj's own CLI uses for `jj log`, so the world
-# graph lays out exactly like jj's. Version matches the jj 0.46.0 workspace pin.
+# graph lays out exactly like jj's.
 sapling-renderdag = "0.1.0"
 serde = { version = "1", features = ["derive"] }
 # arbitrary_precision preserves exact numeric fidelity when the engine
diff --git a/src/engine/workspace.rs b/src/engine/workspace.rs
--- a/src/engine/workspace.rs
+++ b/src/engine/workspace.rs
@@ -1473,7 +1473,7 @@
 /// dependency it describes.
 const JJ_LIB_TARGET: JjVersion = JjVersion {
     major: 0,
-    minor: 46,
+    minor: 47,
 };
 
 /// A warning when the `jj` on `PATH` does not match [`JJ_LIB_TARGET`], the
diff --git a/src/graph.rs b/src/graph.rs
--- a/src/graph.rs
+++ b/src/graph.rs
@@ -6,7 +6,7 @@
 //! layout is built by us from typed commit data.
 //!
 //! jj-lib has no stability guarantee and reads the store format of the installed
-//! `jj`, so its version is locked to the `jj` mise pin (0.46.0) and the two move
+//! `jj`, so its version is locked to the installed `jj` (0.47.1) and the two move
 //! in lockstep. The surface used here is deliberately minimal - open, read heads
 //! and bookmarks, walk parents - to keep the migration cost of a `jj` bump small.
 //!
@@ -21,12 +21,11 @@
 use jj_lib::backend::CommitId;
 use jj_lib::config::StackedConfig;
 use jj_lib::default_backend_factories::{
-    default_backend_factories, default_working_copy_factories,
+    default_backend_factories, default_working_copy_factories, default_workspace_loader_factory,
 };
 use jj_lib::object_id::ObjectId;
 use jj_lib::repo::Repo;
 use jj_lib::settings::UserSettings;
-use jj_lib::workspace::Workspace;
 
 /// One commit in the graph, in display form (owned strings, no jj-lib types leak
 /// out of this module).
@@ -99,17 +98,19 @@
     let home_dir = std::env::var_os("HOME").map(std::path::PathBuf::from);
     let settings = UserSettings::from_config_and_home_dir(StackedConfig::with_defaults(), home_dir)
         .context("build jj settings")?;
-    let workspace = Workspace::load(
-        &settings,
-        repo_root,
-        &default_backend_factories(),
-        &default_working_copy_factories(),
-    )
-    .context("open jj workspace")?;
+    let workspace = default_workspace_loader_factory()
+        .create(repo_root)
+        .context("create jj workspace loader")?
+        .load(
+            &settings,
+            &default_backend_factories(),
+            &default_working_copy_factories(),
+        )
+        .context("open jj workspace")?;
 
     // `load_at_head` is async in jj-lib 0.43; block on it - this whole fn runs on
     // a blocking worker thread (spike 02).
-    let repo = pollster::block_on(workspace.repo_loader().load_at_head())
+    let repo = pollster::block_on(workspace.load_at_head())
         .map_err(|e| anyhow!("load repo at head: {e}"))?;
     let view = repo.view();
     let store = repo.store();
