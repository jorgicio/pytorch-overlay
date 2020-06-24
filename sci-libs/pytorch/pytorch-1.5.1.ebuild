# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

DISTUTILS_OPTIONAL=1

inherit distutils-r1 cmake cuda python-r1 python-utils-r1

DESCRIPTION="Tensors and Dynamic neural networks in Python with strong GPU acceleration"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/facebookincubator/gloo/archive/113bde13.tar.gz -> gloo-113bde13.tar.gz
https://github.com/google/benchmark/archive/505be96a.tar.gz -> benchmark-505be96a.tar.gz
https://github.com/google/gemmlowp/archive/3fb5c176.tar.gz -> gemmlowp-3fb5c176.tar.gz
https://github.com/google/googletest/archive/2fe3bd99.tar.gz -> googletest-2fe3bd99.tar.gz
https://github.com/houseroad/foxi/archive/8015abb7.tar.gz -> foxi-8015abb7.tar.gz
https://github.com/intel/ideep/archive/3fc96899.tar.gz -> ideep-3fc96899.tar.gz
https://github.com/Maratyszcza/FP16/archive/febbb1c1.tar.gz -> FP16-febbb1c1.tar.gz
https://github.com/Maratyszcza/FXdiv/archive/b742d114.tar.gz -> FXdiv-b742d114.tar.gz
https://github.com/Maratyszcza/NNPACK/archive/24b55303.tar.gz -> NNPACK-24b55303.tar.gz
https://github.com/Maratyszcza/PeachPy/archive/07d8fde8.tar.gz -> PeachPy-07d8fde8.tar.gz
https://github.com/Maratyszcza/psimd/archive/10b4ffc6.tar.gz -> psimd-10b4ffc6.tar.gz
https://github.com/Maratyszcza/pthreadpool/archive/d4657476.tar.gz -> pthreadpool-d4657476.tar.gz
cuda? ( https://github.com/NVIDIA/nccl/archive/7c72dee6.tar.gz -> nccl-7c72dee6.tar.gz )
https://github.com/NVlabs/cub/archive/285aeeba.tar.gz -> cub-285aeeba.tar.gz
https://github.com/onnx/onnx/archive/9fdae4c6.tar.gz -> onnx-9fdae4c6.tar.gz
https://github.com/onnx/onnx-tensorrt/archive/c1532114.tar.gz -> onnx-tensorrt-c1532114.tar.gz
https://github.com/pytorch/cpuinfo/archive/0e6bde92.tar.gz -> cpuinfo-0e6bde92.tar.gz
https://github.com/pytorch/fbgemm/archive/e526aadd.tar.gz -> fbgemm-e526aadd.tar.gz
https://github.com/pytorch/QNNPACK/archive/7d2a4e99.tar.gz -> QNNPACK-7d2a4e99.tar.gz
https://github.com/shibatch/sleef/archive/7f523de6.tar.gz -> sleef-7f523de6.tar.gz
https://github.com/asmjit/asmjit/archive/ac77dfcd.tar.gz -> asmjit-ac77dfcd.tar.gz
https://github.com/google/XNNPACK/archive/7493bfb9.tar.gz -> XNNPACK-7493bfb9.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE="asan atlas cuda eigen +fbgemm ffmpeg gflags glog +gloo leveldb lmdb mkl mkldnn mpi namedtensor +nnpack numa +numpy +observers +openblas opencl opencv +openmp +python +qnnpack redis static tbb test tools +xnnpack zeromq"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	numpy? ( python )
	^^ ( atlas eigen mkl openblas )
"

DEPEND="
	dev-libs/protobuf
	dev-python/pyyaml[${PYTHON_USEDEP}]
	virtual/python-typing[${PYTHON_USEDEP}]
	atlas? ( sci-libs/atlas )
	cuda? ( dev-libs/cudnn
		dev-cpp/eigen[cuda] )
	ffmpeg? ( media-video/ffmpeg )
	gflags? ( dev-cpp/gflags )
	glog? ( dev-cpp/glog )
	leveldb? ( dev-libs/leveldb )
	lmdb? ( dev-db/lmdb )
	mkl? ( sci-libs/mkl )
	mpi? ( virtual/mpi )
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
	openblas? ( sci-libs/openblas )
	opencl? ( dev-libs/clhpp virtual/opencl )
	opencv? ( media-libs/opencv )
	python? ( ${PYTHON_DEPS}
		dev-python/pybind11[${PYTHON_USEDEP}]
	)
	redis? ( dev-db/redis )
	zeromq? ( net-libs/zeromq )
	eigen? ( dev-cpp/eigen )
"
RDEPEND="${DEPEND}"
BDEPEND=""

DEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-cpp/tbb
	app-arch/zstd
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	sys-fabric/libibverbs
	sys-process/numactl
"

PATCHES=(
	"${FILESDIR}"/Use-FHS-compliant-paths-from-GNUInstallDirs-module-1.5.0.patch
	"${FILESDIR}"/0002-Don-t-build-libtorch-again-for-PyTorch-1.4.0.patch
	"${FILESDIR}"/0003-Change-path-to-caffe2-build-dir-made-by-libtorch.patch
	"${FILESDIR}"/0004-Don-t-fill-rpath-of-Caffe2-library-for-system-wide-i.patch
	"${FILESDIR}"/0005-Change-library-directory-according-to-CMake-build.patch
	"${FILESDIR}"/0006-Change-torch_path-part-for-cpp-extensions.patch
	"${FILESDIR}"/0007-Add-necessary-include-directory-for-ATen-CPU-tests.patch
	"${FILESDIR}"/Include-neon2sse-third-party-header-library.patch
	"${FILESDIR}"/Use-system-wide-pybind11-properly.patch
	"${FILESDIR}"/Include-mkl-Caffe2-targets-only-when-enabled.patch
	"${FILESDIR}"/Use-platform-dependent-LIBDIR-in-TorchConfig.cmake.in.patch
	"${FILESDIR}"/Fix-path-to-torch_global_deps-library-in-installatio.patch
	"${FILESDIR}"/${PN}-1.5.0-no-tbb.patch
)

src_prepare() {
	cmake_src_prepare

	mv -v third_party/miniz-* ../ || die
	rm -r third_party || die
	ln -s .. third_party || die
	cd .. || die
	for d in *; do
		case ${d} in
			${PN}* | miniz-*) continue ;;
			PeachPy-*) mv -v ${d} python-peachpy || die ;;
			*) mv -v ${d} ${d%-*} || die ;;
		esac
	done

	mv -v FBGEMM fbgemm || die
	cd fbgemm || die
	rm -r third_party || die
	ln -s .. third_party || die

	cd ../onnx || die
	rm -r third_party || die
	ln -s .. third_party || die

	if use cuda; then
		cd ../nccl || die
		eapply "${FILESDIR}"/${PN}-1.4.0-nccl-nvccflags.patch
		ln -s . nccl || die

		cuda_src_prepare
		export CUDAHOSTCXX=$(cuda_gccdir)/g++
	fi
}

src_configure() {
	local blas="Eigen"

	if use atlas; then
		blas="ATLAS"
	elif use mkl; then
		blas="MKL"
	elif use openblas; then
		blas="OpenBLAS"
	fi

	local mycmakeargs=(
		-DTORCH_BUILD_VERSION=${PV}
		-DTORCH_INSTALL_LIB_DIR=$(get_libdir)
		-DBUILD_BINARY=$(usex tools ON OFF)
		-DBUILD_CUSTOM_PROTOBUF=OFF
		-DBUILD_DOCS=OFF
		-DBUILD_PYTHON=$(usex python ON OFF)
		-DBUILD_SHARED_LIBS=$(usex static OFF ON)
		-DBUILD_TEST=$(usex test ON OFF)
		-DUSE_ASAN=$(usex asan ON OFF)
		-DUSE_CUDA=$(usex cuda ON OFF)
		-DUSE_NCCL=$(usex cuda ON OFF)
		-DUSE_SYSTEM_NCCL=OFF
		-DUSE_ROCM=OFF
		-DUSE_FBGEMM=$(usex fbgemm ON OFF)
		-DUSE_FFMPEG=$(usex ffmpeg ON OFF)
		-DUSE_GFLAGS=$(usex gflags ON OFF)
		-DUSE_GLOG=$(usex glog ON OFF)
		-DUSE_LEVELDB=$(usex leveldb ON OFF)
		-DUSE_LITE_PROTO=OFF
		-DUSE_LMDB=$(usex lmdb ON OFF)
		-DCAFFE2_USE_MKL=$(usex mkl ON OFF)
		-DUSE_MKLDNN=$(usex mkldnn ON OFF)
		-DUSE_MKLDNN_CBLAS=OFF
		-DUSE_NNPACK=$(usex nnpack ON OFF)
		-DUSE_NUMPY=$(usex numpy ON OFF)
		-DUSE_NUMA=$(usex numa ON OFF)
		-DUSE_OBSERVERS=$(usex observers ON OFF)
		-DUSE_OPENCL=$(usex opencl ON OFF)
		-DUSE_OPENCV=$(usex opencv ON OFF)
		-DUSE_OPENMP=$(usex openmp ON OFF)
		-DUSE_TBB=OFF
		-DUSE_PROF=OFF
		-DUSE_QNNPACK=$(usex qnnpack ON OFF)
		-DUSE_REDIS=$(usex redis ON OFF)
		-DUSE_ROCKSDB=OFF
		-DUSE_XNNPACK=$(usex xnnpack ON OFF)
		-DUSE_ZMQ=$(usex zeromq ON OFF)
		-DUSE_MPI=$(usex mpi ON OFF)
		-DUSE_GLOO=$(usex gloo ON OFF)
		-DUSE_SYSTEM_EIGEN_INSTALL=ON
		-DBLAS=${blas}
		-DBUILDING_SYSTEM_WIDE=ON
	)

	cmake_src_configure

	if use python; then
		distutils-r1_src_configure
	fi
}

src_compile() {
	cmake_src_compile

	if use python; then
		CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_compile
	fi
}

src_install() {
	cmake_src_install

	local multilib_failing_files=(
		libgloo.a
		libsleef.a
	)

	for file in ${multilib_failing_files[@]}; do
		mv -fv "${ED}/usr/lib/$file" "${ED}/usr/$(get_libdir)"
	done

	rm -rfv "${ED}/torch"
	rm -rfv "${ED}/var"
	rm -rfv "${ED}/usr/lib"

	rm -rfv "${ED}/usr/include/fp16"
	rm -rfv "${ED}/usr/include/fp16.h"

	rm -fv "${ED}/usr/lib64/libtbb.so"
	rm -rfv "${ED}/usr/lib64/cmake"

	if use python; then
		install_shm_manager() {
			python_get_sitedir
			TORCH_BIN_DIR="${ED}/${PYTHON_SITEDIR}/torch/bin"

			mkdir -pv ${TORCH_BIN_DIR}
			cp -v "${ED}/usr/bin/torch_shm_manager" "${TORCH_BIN_DIR}" || die
		}

		python_foreach_impl install_shm_manager
		rm "${ED}"/usr/bin/torch_shm_manager || die

		remove_tests() {
			find "${ED}" -name "*test*" -exec rm -rfv {} \;
		}

		scanelf -r --fix "${BUILD_DIR}/caffe2/python"
		CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_install

		fix_caffe_convert_utils() {
			python_setup
			python_get_scriptdir
			ln -rnsvf "${ED}/${PYTHON_SCRIPTDIR}/convert-caffe2-to-onnx" "${ED}/usr/bin/" || die
			ln -rnsvf "${ED}/${PYTHON_SCRIPTDIR}/convert-onnx-to-caffe2" "${ED}/usr/bin/" || die
		}

		fix_caffe_convert_utils

		if use test; then
			python_foreach_impl remove_tests
		fi

		python_foreach_impl python_optimize
	fi

	find "${ED}/usr/lib64" -name "*.a" -exec rm -fv {} \;

	use test && rm -rfv "${ED}/usr/test" "${ED}"/usr/bin/test_{api,jit}

	# Remove the empty directories by CMake Python:
	find "${ED}" -type d -empty -delete || die
}
