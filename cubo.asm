; Vulkan cube renderer written in pure assembly for Linux x86-64
; To assemble: nasm -f elf64 vulkan_cube.asm -o vulkan_cube.o
; To link: ld vulkan_cube.o -o vulkan_cube -lX11 -lvulkan -lxcb -lX11-xcb -lxkbcommon -ldl -lm

; Define constants
%define VK_STRUCTURE_TYPE_APPLICATION_INFO 0
%define VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO 1
%define VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO 2
%define VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO 3
%define VK_STRUCTURE_TYPE_SUBMIT_INFO 4
%define VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO 5
%define VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO 6
%define VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO 7
%define VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO 8
%define VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO 9
%define VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO 10
%define VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO 11
%define VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO 12
%define VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO 13
%define VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO 14
%define VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO 15
%define VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO 16
%define VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO 17
%define VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR 1000001000
%define VK_STRUCTURE_TYPE_PRESENT_INFO_KHR 1000001001
%define VK_STRUCTURE_TYPE_XCB_SURFACE_CREATE_INFO_KHR 1000005000
%define VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_2_KHR 1000119001
%define VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2 1000059000

%define VK_QUEUE_GRAPHICS_BIT 0x00000001
%define VK_QUEUE_COMPUTE_BIT 0x00000002
%define VK_QUEUE_TRANSFER_BIT 0x00000004

%define VK_NULL_HANDLE 0

%define VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT 0x00000001
%define VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT 0x00000002
%define VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT 0x00000400

%define VK_IMAGE_LAYOUT_UNDEFINED 0
%define VK_IMAGE_LAYOUT_PRESENT_SRC_KHR 1000001002
%define VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL 2

%define VK_SUBPASS_CONTENTS_INLINE 0

%define VK_FORMAT_B8G8R8A8_SRGB 50
%define VK_COLOR_SPACE_SRGB_NONLINEAR_KHR 0

%define VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST 3
%define VK_POLYGON_MODE_FILL 0

%define VK_SAMPLE_COUNT_1_BIT 0x00000001
%define VK_DYNAMIC_STATE_VIEWPORT 0
%define VK_DYNAMIC_STATE_SCISSOR 1

%define VK_SHADER_STAGE_VERTEX_BIT 0x00000001
%define VK_SHADER_STAGE_FRAGMENT_BIT 0x00000010

%define VK_SUCCESS 0
%define VK_NOT_READY 1
%define VK_TIMEOUT 2
%define VK_EVENT_SET 3
%define VK_EVENT_RESET 4
%define VK_INCOMPLETE 5
%define VK_ERROR_OUT_OF_HOST_MEMORY -1
%define VK_ERROR_OUT_OF_DEVICE_MEMORY -2
%define VK_ERROR_INITIALIZATION_FAILED -3
%define VK_ERROR_DEVICE_LOST -4
%define VK_ERROR_MEMORY_MAP_FAILED -5
%define VK_ERROR_LAYER_NOT_PRESENT -6
%define VK_ERROR_EXTENSION_NOT_PRESENT -7
%define VK_ERROR_FEATURE_NOT_PRESENT -8
%define VK_ERROR_INCOMPATIBLE_DRIVER -9
%define VK_ERROR_TOO_MANY_OBJECTS -10
%define VK_ERROR_FORMAT_NOT_SUPPORTED -11
%define VK_ERROR_SURFACE_LOST_KHR -1000000000

%define VK_ATTACHMENT_LOAD_OP_CLEAR 1
%define VK_ATTACHMENT_STORE_OP_STORE 0

; Window size
%define WINDOW_WIDTH 800
%define WINDOW_HEIGHT 600

section .data
    ; Window data
    window_title db "Vulkan Cube (Assembly)", 0
    
    ; Vulkan instance information
    appName db "VulkanCubeAssembly", 0
    engineName db "No Engine", 0
    instanceExtensions dq VK_KHR_SURFACE_EXTENSION_NAME, VK_KHR_XCB_SURFACE_EXTENSION_NAME
    numInstanceExtensions equ 2
    
    ; Vulkan device information
    deviceExtensions dq VK_KHR_SWAPCHAIN_EXTENSION_NAME
    numDeviceExtensions equ 1
    
    ; Vulkan layers
    validationLayerName db "VK_LAYER_KHRONOS_validation", 0
    validationLayers dq validationLayerName
    numValidationLayers equ 1
    
    ; Function pointers to Vulkan API
    vkGetInstanceProcAddr dq 0
    vkCreateInstance dq 0
    vkDestroyInstance dq 0
    vkEnumeratePhysicalDevices dq 0
    vkGetPhysicalDeviceProperties dq 0
    vkGetPhysicalDeviceQueueFamilyProperties dq 0
    vkGetPhysicalDeviceSurfaceCapabilitiesKHR dq 0
    vkGetPhysicalDeviceSurfaceFormatsKHR dq 0
    vkGetPhysicalDeviceSurfacePresentModesKHR dq 0
    vkGetPhysicalDeviceSurfaceSupportKHR dq 0
    vkCreateDevice dq 0
    vkDestroyDevice dq 0
    vkGetDeviceQueue dq 0
    vkCreateSwapchainKHR dq 0
    vkDestroySwapchainKHR dq 0
    vkGetSwapchainImagesKHR dq 0
    vkCreateImageView dq 0
    vkDestroyImageView dq 0
    vkCreateShaderModule dq 0
    vkDestroyShaderModule dq 0
    vkCreatePipelineLayout dq 0
    vkDestroyPipelineLayout dq 0
    vkCreateRenderPass dq 0
    vkDestroyRenderPass dq 0
    vkCreateGraphicsPipelines dq 0
    vkDestroyPipeline dq 0
    vkCreateFramebuffer dq 0
    vkDestroyFramebuffer dq 0
    vkCreateCommandPool dq 0
    vkDestroyCommandPool dq 0
    vkAllocateCommandBuffers dq 0
    vkFreeCommandBuffers dq 0
    vkBeginCommandBuffer dq 0
    vkCmdBeginRenderPass dq 0
    vkCmdBindPipeline dq 0
    vkCmdSetViewport dq 0
    vkCmdSetScissor dq 0
    vkCmdDraw dq 0
    vkCmdEndRenderPass dq 0
    vkEndCommandBuffer dq 0
    vkCreateSemaphore dq 0
    vkDestroySemaphore dq 0
    vkCreateFence dq 0
    vkDestroyFence dq 0
    vkResetFences dq 0
    vkWaitForFences dq 0
    vkAcquireNextImageKHR dq 0
    vkQueueSubmit dq 0
    vkQueuePresentKHR dq 0
    vkDeviceWaitIdle dq 0
    vkCreateBuffer dq 0
    vkGetBufferMemoryRequirements dq 0
    vkAllocateMemory dq 0
    vkBindBufferMemory dq 0
    vkMapMemory dq 0
    vkUnmapMemory dq 0
    vkDestroyBuffer dq 0
    vkFreeMemory dq 0
    vkCreateDescriptorSetLayout dq 0
    vkDestroyDescriptorSetLayout dq 0
    vkCreateDescriptorPool dq 0
    vkDestroyDescriptorPool dq 0
    vkAllocateDescriptorSets dq 0
    vkUpdateDescriptorSets dq 0
    vkCmdBindDescriptorSets dq 0
    vkCmdBindVertexBuffers dq 0
    vkCmdBindIndexBuffer dq 0
    vkCmdDrawIndexed dq 0
    vkGetPhysicalDeviceMemoryProperties dq 0
    vkCreateXcbSurfaceKHR dq 0
    vkDestroySurfaceKHR dq 0
    
    ; X11 related data
    x11_display dq 0
    x11_window dq 0
    x11_connection dq 0
    x11_screen dq 0
    
    ; Vulkan instance and device data
    vk_instance dq 0
    vk_physical_device dq 0
    vk_device dq 0
    vk_surface dq 0
    vk_swapchain dq 0
    vk_queue_family_index dq 0
    vk_graphics_queue dq 0
    vk_present_queue dq 0
    
    ; Validation layers enabled flag
    validation_layers_enabled dq 1
    
    ; Vulkan device limits
    max_frames_in_flight dq 2
    current_frame dq 0
    
    ; Framebuffer size
    framebuffer_resized db 0
    
    ; Render resources
    vk_pipeline_layout dq 0
    vk_render_pass dq 0
    vk_graphics_pipeline dq 0
    vk_command_pool dq 0
    vk_vertex_buffer dq 0
    vk_vertex_buffer_memory dq 0
    vk_index_buffer dq 0
    vk_index_buffer_memory dq 0
    
    ; Synchronization objects
    image_available_semaphores dq 0, 0
    render_finished_semaphores dq 0, 0
    in_flight_fences dq 0, 0
    
    ; Error messages
    msg_vulkan_init_failed db "Failed to initialize Vulkan", 10, 0
    msg_window_create_failed db "Failed to create window", 10, 0
    msg_surface_create_failed db "Failed to create Vulkan surface", 10, 0
    msg_device_create_failed db "Failed to create logical device", 10, 0
    msg_swapchain_create_failed db "Failed to create swapchain", 10, 0
    msg_pipeline_create_failed db "Failed to create graphics pipeline", 10, 0
    msg_commandpool_create_failed db "Failed to create command pool", 10, 0
    msg_buffer_create_failed db "Failed to create buffers", 10, 0
    msg_sync_create_failed db "Failed to create sync objects", 10, 0
    
    ; X11 protocols
    atom_wm_protocols dq 0
    atom_wm_delete_window dq 0
    
    ; Shader modules
    vertex_shader_module dq 0
    fragment_shader_module dq 0
    
    ; Vertex data for the cube
    vertices_data:
        ; Front face
        dd -0.5, -0.5,  0.5      ; vertex 0: position (x, y, z)
        dd  1.0,  0.0,  0.0      ; vertex 0: color (r, g, b)
        dd  0.5, -0.5,  0.5      ; vertex 1
        dd  0.0,  1.0,  0.0
        dd  0.5,  0.5,  0.5      ; vertex 2
        dd  0.0,  0.0,  1.0
        dd -0.5,  0.5,  0.5      ; vertex 3
        dd  1.0,  1.0,  1.0
        
        ; Back face
        dd -0.5, -0.5, -0.5      ; vertex 4
        dd  1.0,  0.0,  1.0
        dd  0.5, -0.5, -0.5      ; vertex 5
        dd  0.0,  1.0,  1.0
        dd  0.5,  0.5, -0.5      ; vertex 6
        dd  1.0,  1.0,  0.0
        dd -0.5,  0.5, -0.5      ; vertex 7
        dd  0.0,  0.0,  0.0
    vertices_size equ $ - vertices_data
    
    ; Index data for the cube
    indices_data:
        ; Front face
        dw 0, 1, 2
        dw 2, 3, 0
        
        ; Right face
        dw 1, 5, 6
        dw 6, 2, 1
        
        ; Back face
        dw 5, 4, 7
        dw 7, 6, 5
        
        ; Left face
        dw 4, 0, 3
        dw 3, 7, 4
        
        ; Top face
        dw 3, 2, 6
        dw 6, 7, 3
        
        ; Bottom face
        dw 4, 5, 1
        dw 1, 0, 4
    indices_size equ $ - indices_data
    indices_count equ (indices_size / 2)
    
    ; SPIR-V shader bytecode
    vertex_shader_code:
        ; SPIR-V code for vertex shader
        dd 0x07230203, 0x00010000, 0x00080001, 0x0000002e
        dd 0x00000000, 0x00020011, 0x00000001, 0x0006000b
        dd 0x00000001, 0x4c534c47, 0x6474732e, 0x3035342e
        dd 0x00000000, 0x0003000e, 0x00000000, 0x00000001
        dd 0x0009000f, 0x00000000, 0x00000004, 0x6e69616d
        dd 0x00000000, 0x0000000a, 0x0000000c, 0x00000016
        dd 0x0000001c, 0x00030003, 0x00000002, 0x000001c2
        dd 0x00040005, 0x00000004, 0x6e69616d, 0x00000000
        dd 0x00060005, 0x00000008, 0x505f6c67, 0x65567265
        dd 0x78657472, 0x00000000, 0x00060006, 0x00000008
        dd 0x00000000, 0x505f6c67, 0x7469736f, 0x006e6f69
        dd 0x00070006, 0x00000008, 0x00000001, 0x505f6c67
        dd 0x746e696f, 0x657a6953, 0x00000000
        dd 0x00070006, 0x00000008, 0x00000002, 0x435f6c67
        dd 0x4470696c, 0x61747369, 0x0065636e, 0x00070006
        dd 0x00000008, 0x00000003, 0x435f6c67, 0x446c6c75
        dd 0x61747369, 0x0065636e, 0x00030005, 0x0000000a
        dd 0x00000000, 0x00050005, 0x0000000c, 0x69736f70
        dd 0x6e6f6974, 0x00000000, 0x00040005, 0x00000016
        dd 0x6f6c6f63, 0x00000072, 0x00050005, 0x0000001c
        dd 0x67617266, 0x6f6c6f43, 0x00000072, 0x00050048
        dd 0x00000008, 0x00000000, 0x0000000b, 0x00000000
        dd 0x00050048, 0x00000008, 0x00000001, 0x0000000b
        dd 0x00000001, 0x00050048, 0x00000008, 0x00000002
        dd 0x0000000b, 0x00000003, 0x00050048, 0x00000008
        dd 0x00000003, 0x0000000b, 0x00000004, 0x00030047
        dd 0x00000008, 0x00000002, 0x00040047, 0x0000000c
        dd 0x0000001e, 0x00000000, 0x00040047, 0x00000016
        dd 0x0000001e, 0x00000001, 0x00040047, 0x0000001c
        dd 0x0000001e, 0x00000000, 0x00020013, 0x00000002
        dd 0x00030021, 0x00000003, 0x00000002, 0x00030016
        dd 0x00000006, 0x00000020, 0x00040017, 0x00000007
        dd 0x00000006, 0x00000004, 0x0004001e, 0x00000008
        dd 0x00000007, 0x00000006, 0x00040020, 0x00000009
        dd 0x00000003, 0x00000008, 0x0004003b, 0x00000009
        dd 0x0000000a, 0x00000003, 0x00040017, 0x0000000b
        dd 0x00000006, 0x00000003, 0x00040020, 0x0000000b
        dd 0x00000001, 0x0000000b, 0x0004003b, 0x0000000b
        dd 0x0000000c, 0x00000001, 0x00040015, 0x0000000d
        dd 0x00000020, 0x00000000, 0x0004002b, 0x0000000d
        dd 0x0000000e, 0x00000001, 0x00040020, 0x0000000f
        dd 0x00000001, 0x00000006, 0x0004002b, 0x0000000d
        dd 0x00000011, 0x00000000, 0x00040020, 0x00000012
        dd 0x00000001, 0x0000000d, 0x00040017, 0x00000014
        dd 0x00000006, 0x00000004, 0x00040020, 0x00000015
        dd 0x00000001, 0x00000014, 0x0004003b, 0x00000015
        dd 0x00000016, 0x00000001, 0x00040020, 0x00000018
        dd 0x00000003, 0x00000007, 0x0004002b, 0x00000006
        dd 0x0000001a, 0x3f800000, 0x00040020, 0x0000001b
        dd 0x00000003, 0x00000014, 0x0004003b, 0x0000001b
        dd 0x0000001c, 0x00000003, 0x00050036, 0x00000002
        dd 0x00000004, 0x00000000, 0x00000003, 0x000200f8
        dd 0x00000005, 0x0004003d, 0x0000000b, 0x0000000b
        dd 0x0000000c, 0x00050041, 0x0000000f, 0x00000010
        dd 0x0000000c, 0x0000000e, 0x0004003d, 0x00000006
        dd 0x00000011, 0x00000010, 0x00050041, 0x00000012
        dd 0x00000013, 0x0000000c, 0x00000011, 0x0004003d
        dd 0x0000000d, 0x00000014, 0x00000013, 0x00050051
        dd 0x00000006, 0x00000015, 0x0000000b, 0x00000000
        dd 0x00050051, 0x00000006, 0x00000016, 0x0000000b
        dd 0x00000001, 0x00050051, 0x00000006, 0x00000017
        dd 0x0000000b, 0x00000002, 0x00070050, 0x00000007
        dd 0x00000018, 0x00000015, 0x00000016, 0x00000017
        dd 0x0000001a, 0x00050041, 0x00000018, 0x00000019
        dd 0x0000000a, 0x00000011, 0x0003003e, 0x00000019
        dd 0x00000018, 0x0004003d, 0x00000014, 0x0000001d
        dd 0x00000016, 0x0003003e, 0x0000001c, 0x0000001d
        dd 0x000100fd, 0x00010038
    vertex_shader_size equ $ - vertex_shader_code
    
    fragment_shader_code:
        ; SPIR-V code for fragment shader
        dd 0x07230203, 0x00010000, 0x00080001, 0x0000000d
        dd 0x00000000, 0x00020011, 0x00000001, 0x0006000b
        dd 0x00000001, 0x4c534c47, 0x6474732e, 0x3035342e
        dd 0x00000000, 0x0003000e, 0x00000000, 0x00000001
        dd 0x0007000f, 0x00000004, 0x00000004, 0x6e69616d
        dd 0x00000000, 0x00000009, 0x0000000b, 0x00030010
        dd 0x00000004, 0x00000007, 0x00030003, 0x00000002
        dd 0x000001c2, 0x00040005, 0x00000004, 0x6e69616d
        dd 0x00000000, 0x00050005, 0x00000009, 0x67617266
        dd 0x6f6c6f43, 0x00000072, 0x00040005, 0x0000000b
        dd 0x6f6c6f63, 0x00000072, 0x00040047, 0x00000009
        dd 0x0000001e, 0x00000000, 0x00040047, 0x0000000b
        dd 0x0000001e, 0x00000000, 0x00020013, 0x00000002
        dd 0x00030021, 0x00000003, 0x00000002, 0x00030016
        dd 0x00000006, 0x00000020, 0x00040017, 0x00000007
        dd 0x00000006, 0x00000004, 0x00040020, 0x00000008
        dd 0x00000003, 0x00000007, 0x0004003b, 0x00000008
        dd 0x00000009, 0x00000003, 0x00040020, 0x0000000a
        dd 0x00000001, 0x00000007, 0x0004003b, 0x0000000a
        dd 0x0000000b, 0x00000001, 0x00050036, 0x00000002
        dd 0x00000004, 0x00000000, 0x00000003, 0x000200f8
        dd 0x00000005, 0x0004003d, 0x00000007, 0x0000000c
        dd 0x0000000b, 0x0003003e, 0x00000009, 0x0000000c
        dd 0x000100fd, 0x00010038
    fragment_shader_size equ $ - fragment_shader_code
    
    ; Swapchain images
    swapchain_images dq 0
    swapchain_image_count dq 0
    swapchain_image_views dq 0
    swapchain_framebuffers dq 0
    swapchain_image_format dq 0
    swapchain_extent dq 0, 0  ; width, height
    
    ; Command buffers
    command_buffers dq 0
    
    ; Clear color for rendering
    clear_color:
        dd 0.0, 0.0, 0.0, 1.0  ; Black background
    
    ; Function name strings for Vulkan
    VK_KHR_SURFACE_EXTENSION_NAME db "VK_KHR_surface", 0
    VK_KHR_XCB_SURFACE_EXTENSION_NAME db "VK_KHR_xcb_surface", 0
    VK_KHR_SWAPCHAIN_EXTENSION_NAME db "VK_KHR_swapchain", 0
    str_vkGetInstanceProcAddr db "vkGetInstanceProcAddr", 0
    str_vkCreateInstance db "vkCreateInstance", 0
    str_vkDestroyInstance db "vkDestroyInstance", 0
    str_vkEnumeratePhysicalDevices db "vkEnumeratePhysicalDevices", 0
    str_vkGetPhysicalDeviceProperties db "vkGetPhysicalDeviceProperties", 0
    str_vkGetPhysicalDeviceQueueFamilyProperties db "vkGetPhysicalDeviceQueueFamilyProperties", 0
    str_vkGetPhysicalDeviceSurfaceCapabilitiesKHR db "vkGetPhysicalDeviceSurfaceCapabilitiesKHR", 0
    str_vkGetPhysicalDeviceSurfaceFormatsKHR db "vkGetPhysicalDeviceSurfaceFormatsKHR", 0
    str_vkGetPhysicalDeviceSurfacePresentModesKHR db "vkGetPhysicalDeviceSurfacePresentModesKHR", 0
    str_vkGetPhysicalDeviceSurfaceSupportKHR db "vkGetPhysicalDeviceSurfaceSupportKHR", 0
    str_vkCreateDevice db "vkCreateDevice", 0
    str_vkDestroyDevice db "vkDestroyDevice", 0
    str_vkGetDeviceQueue db "vkGetDeviceQueue", 0
    str_vkCreateSwapchainKHR db "vkCreateSwapchainKHR", 0
    str_vkDestroySwapchainKHR db "vkDestroySwapchainKHR", 0
    str_vkGetSwapchainImagesKHR db "vkGetSwapchainImagesKHR", 0
    str_vkCreateImageView db "vkCreateImageView", 0
    str_vkDestroyImageView db "vkDestroyImageView", 0
    str_vkCreateShaderModule db "vkCreateShaderModule", 0
    str_vkDestroyShaderModule db "vkDestroyShaderModule", 0
    str_vkCreatePipelineLayout db "vkCreatePipelineLayout", 0
    str_vkDestroyPipelineLayout db "vkDestroyPipelineLayout", 0
    str_vkCreateRenderPass db "vkCreateRenderPass", 0
    str_vkDestroyRenderPass db "vkDestroyRenderPass", 0
    str_vkCreateGraphicsPipelines db "vkCreateGraphicsPipelines", 0
    str_vkDestroyPipeline db "vkDestroyPipeline", 0
    str_vkCreateFramebuffer db "vkCreateFramebuffer", 0
    str_vkDestroyFramebuffer db "vkDestroyFramebuffer", 0
    str_vkCreateCommandPool db "vkCreateCommandPool", 0
    str_vkDestroyCommandPool db "vkDestroyCommandPool", 0
    str_vkAllocateCommandBuffers db "vkAllocateCommandBuffers", 0
    str_vkFreeCommandBuffers db "vkFreeCommandBuffers", 0
    str_vkBeginCommandBuffer db "vkBeginCommandBuffer", 0
    str_vkCmdBeginRenderPass db "vkCmdBeginRenderPass", 0
    str_vkCmdBindPipeline db "vkCmdBindPipeline", 0
    str_vkCmdSetViewport db "vkCmdSetViewport", 0
    str_vkCmdSetScissor db "vkCmdSetScissor", 0
    str_vkCmdDraw db "vkCmdDraw", 0
    str_vkCmdDrawIndexed db "vkCmdDrawIndexed", 0
    str_vkCmdEndRenderPass db "vkCmdEndRenderPass", 0
    str_vkEndCommandBuffer db "vkEndCommandBuffer", 0
    str_vkCreateSemaphore db "vkCreateSemaphore", 0
    str_vkDestroySemaphore db "vkDestroySemaphore", 0
    str_vkCreateFence db "vkCreateFence", 0
    str_vkDestroyFence db "vkDestroyFence", 0
    str_vkResetFences db "vkResetFences", 0
    str_vkWaitForFences db "vkWaitForFences", 0
    str_vkAcquireNextImageKHR db "vkAcquireNextImageKHR", 0
    str_vkQueueSubmit db "vkQueueSubmit", 0
    str_vkQueuePresentKHR db "vkQueuePresentKHR", 0
    str_vkDeviceWaitIdle db "vkDeviceWaitIdle", 0
    str_vkCreateBuffer db "vkCreateBuffer", 0
    str_vkGetBufferMemoryRequirements db "vkGetBufferMemoryRequirements", 0
    str_vkAllocateMemory db "vkAllocateMemory", 0
    str_vkBindBufferMemory db "vkBindBufferMemory", 0
    str_vkMapMemory db "vkMapMemory", 0
    str_vkUnmapMemory db "vkUnmapMemory", 0
    str_vkDestroyBuffer db "vkDestroyBuffer", 0
    str_vkFreeMemory db "vkFreeMemory", 0
    str_vkCreateXcbSurfaceKHR db "vkCreateXcbSurfaceKHR", 0
    str_vkDestroySurfaceKHR db "vkDestroySurfaceKHR", 0
    str_vkGetPhysicalDeviceMemoryProperties db "vkGetPhysicalDeviceMemoryProperties", 0
    
    ; X11 library
    lib_x11 db "libX11.so", 0
    lib_vulkan db "libvulkan.so.1", 0
    lib_xcb db "libxcb.so", 0
    lib_x11xcb db "libX11-xcb.so", 0
    
    ; X11 function names
    str_XOpenDisplay db "XOpenDisplay", 0
    str_XCreateSimpleWindow db "XCreateSimpleWindow", 0
    str_XDestroyWindow db "XDestroyWindow", 0
    str_XMapWindow db "XMapWindow", 0
    str_XStoreName db "XStoreName", 0
    str_XInternAtom db "XInternAtom", 0
    str_XSetWMProtocols db "XSetWMProtocols", 0
    str_XPending db "XPending", 0
    str_XNextEvent db "XNextEvent", 0
    str_XCloseDisplay db "XCloseDisplay", 0
    str_XGetXCBConnection db "XGetXCBConnection", 0
    
    ; X11 function pointers
    XOpenDisplay dq 0
    XCreateSimpleWindow dq 0
    XDestroyWindow dq 0
    XMapWindow dq 0
    XStoreName dq 0
    XInternAtom dq 0
    XSetWMProtocols dq 0
    XPending dq 0
    XNextEvent dq 0
    XCloseDisplay dq 0
    XGetXCBConnection dq 0
    
    ; Debug strings
    debug_init_vulkan db "Initializing Vulkan...", 10, 0
    debug_init_window db "Creating window...", 10, 0
    debug_init_surface db "Creating Vulkan surface...", 10, 0
    debug_create_swapchain db "Creating swapchain...", 10, 0
    debug_create_pipeline db "Creating graphics pipeline...", 10, 0
    debug_create_framebuffers db "Creating framebuffers...", 10, 0
    debug_create_commandpool db "Creating command pool...", 10, 0
    debug_create_commandbuffers db "Creating command buffers...", 10, 0
    debug_create_syncobjects db "Creating synchronization objects...", 10, 0
    debug_cleanup db "Cleaning up resources...", 10, 0
    debug_mainloop db "Entering main loop...", 10, 0
    
    ; Memory allocation for Vulkan handles
    memory_allocation_info:
        dd VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO  ; sType
        dq 0                                       ; pNext
        dq 0                                       ; allocationSize
        dd 0                                       ; memoryTypeIndex
    
    ; Format for debugging
    debug_format db "%s", 0
    number_format db "%d", 10, 0
    
section .bss
    ; X11 event structure (typically 96 bytes)
    x_event resb 96
    
    ; Buffer for storing queue family properties
    queue_family_properties resb 1024
    queue_family_count resq 1
    
    ; Swapchain support details
    surface_formats resb 1024
    surface_format_count resq 1
    present_modes resb 512
    present_mode_count resq 1
    surface_capabilities resb 64
    
    ; Physical device memory properties
    memory_properties resb 1024
    
    ; Buffer for storing physical devices
    physical_devices resb 1024
    physical_device_count resq 1
    
section .text
    global _start

; -----------------------------------------------------------------------
; Entry point
; -----------------------------------------------------------------------
_start:
    ; Set up stack frame
    push rbp
    mov rbp, rsp
    sub rsp, 128  ; Space for local variables
    
    ; Print initialization message
    mov rdi, debug_init_vulkan
    call print_string
    
    ; Initialize Vulkan
    call init_vulkan
    test rax, rax
    jz .error_vulkan_init
    
    ; Create window
    mov rdi, debug_init_window
    call print_string
    
    call create_window
    test rax, rax
    jz .error_window_create
    
    ; Create Vulkan surface
    mov rdi, debug_init_surface
    call print_string
    
    call create_surface
    test rax, rax
    jz .error_surface_create
    
    ; Create logical device
    call create_logical_device
    test rax, rax
    jz .error_device_create
    
    ; Create swap chain
    mov rdi, debug_create_swapchain
    call print_string
    
    call create_swapchain
    test rax, rax
    jz .error_swapchain_create
    
    ; Create image views
    call create_image_views
    test rax, rax
    jz .error_imageviews_create
    
    ; Create render pass
    call create_render_pass
    test rax, rax
    jz .error_renderpass_create
    
    ; Create shader modules
    call create_shader_modules
    test rax, rax
    jz .error_shaders_create
    
    ; Create graphics pipeline
    mov rdi, debug_create_pipeline
    call print_string
    
    call create_graphics_pipeline
    test rax, rax
    jz .error_pipeline_create
    
    ; Create framebuffers
    mov rdi, debug_create_framebuffers
    call print_string
    
    call create_framebuffers
    test rax, rax
    jz .error_framebuffers_create
    
    ; Create command pool
    mov rdi, debug_create_commandpool
    call print_string
    
    call create_command_pool
    test rax, rax
    jz .error_commandpool_create
    
    ; Create vertex buffer
    call create_vertex_buffer
    test rax, rax
    jz .error_vertex_buffer_create
    
    ; Create index buffer
    call create_index_buffer
    test rax, rax
    jz .error_index_buffer_create
    
    ; Create command buffers
    mov rdi, debug_create_commandbuffers
    call print_string
    
    call create_command_buffers
    test rax, rax
    jz .error_commandbuffers_create
    
    ; Create synchronization objects
    mov rdi, debug_create_syncobjects
    call print_string
    
    call create_sync_objects
    test rax, rax
    jz .error_syncobjects_create
    
    ; Main loop
    mov rdi, debug_mainloop
    call print_string
    
    call main_loop
    
    ; Cleanup
.cleanup:
    mov rdi, debug_cleanup
    call print_string
    
    call cleanup
    
    ; Exit program
    mov rdi, 0  ; Exit code 0 (success)
    call exit
    
.error_vulkan_init:
    mov rdi, msg_vulkan_init_failed
    call print_string
    mov rdi, 1
    call exit
    
.error_window_create:
    mov rdi, msg_window_create_failed
    call print_string
    call cleanup
    mov rdi, 1
    call exit
    
.error_surface_create:
    mov rdi, msg_surface_create_failed
    call print_string
    call cleanup
    mov rdi, 1
    call exit
    
.error_device_create:
    mov rdi, msg_device_create_failed
    call print_string
    call cleanup
    mov rdi, 1
    call exit
    
.error_swapchain_create:
    mov rdi, msg_swapchain_create_failed
    call print_string
    call cleanup
    mov rdi, 1
    call exit
    
.error_imageviews_create:
    mov rdi, msg_pipeline_create_failed
    call print_string
    call cleanup
    mov rdi, 1
    call exit
    
.error_renderpass_create:
    mov rdi, msg_pipeline_create_failed
    call print_string
    call cleanup
    mov rdi, 1
    call exit
    
.error_shaders_create:
    mov rdi, msg_pipeline_create_failed
    call print_string
    call cleanup
    mov rdi, 1
    call exit
    
.error_pipeline_create:
    mov rdi, msg_pipeline_create_failed
    call print_string
    call cleanup
    mov rdi, 1
    call exit
    
.error_framebuffers_create:
    mov rdi, msg_pipeline_create_failed
    call print_string
    call cleanup
    mov rdi, 1
    call exit
    
.error_commandpool_create:
    mov rdi, msg_commandpool_create_failed
    call print_string
    call cleanup
    mov rdi, 1
    call exit
    
.error_vertex_buffer_create:
    mov rdi, msg_buffer_create_failed
    call print_string
    call cleanup
    mov rdi, 1
    call exit
    
.error_index_buffer_create:
    mov rdi, msg_buffer_create_failed
    call print_string
    call cleanup
    mov rdi, 1
    call exit
    
.error_commandbuffers_create:
    mov rdi, msg_commandpool_create_failed
    call print_string
    call cleanup
    mov rdi, 1
    call exit
    
.error_syncobjects_create:
    mov rdi, msg_sync_create_failed
    call print_string
    call cleanup
    mov rdi, 1
    call exit

; -----------------------------------------------------------------------
; Initializes Vulkan library
; -----------------------------------------------------------------------
init_vulkan:
    push rbp
    mov rbp, rsp
    sub rsp, 512  ; Space for local variables
    
    ; Load Vulkan library
    mov rdi, lib_vulkan
    call dlopen
    test rax, rax
    jz .error
    
    ; Get vkGetInstanceProcAddr function pointer
    mov rdi, rax  ; handle to Vulkan library
    mov rsi, str_vkGetInstanceProcAddr
    call dlsym
    test rax, rax
    jz .error
    
    mov [vkGetInstanceProcAddr], rax
    
    ; Create Vulkan instance
    call create_instance
    test rax, rax
    jz .error
    
    ; Success
    mov rax, 1
    jmp .end
    
.error:
    mov rax, 0
    
.end:
    add rsp, 512
    pop rbp
    ret

; -----------------------------------------------------------------------
; Create Vulkan instance
; -----------------------------------------------------------------------
create_instance:
    push rbp
    mov rbp, rsp
    sub rsp, 1024  ; Space for local variables
    
    ; Prepare application info
    lea rdi, [rbp - 56]  ; Space for VkApplicationInfo
    mov DWORD [rdi], VK_STRUCTURE_TYPE_APPLICATION_INFO  ; sType
    mov QWORD [rdi + 8], 0   ; pNext
    mov QWORD [rdi + 16], appName  ; pApplicationName
    mov DWORD [rdi + 24], 1  ; applicationVersion
    mov QWORD [rdi + 32], engineName  ; pEngineName
    mov DWORD [rdi + 40], 1  ; engineVersion
    mov DWORD [rdi + 48], 0x00401000  ; apiVersion (Vulkan 1.1.0)
    
    ; Prepare instance create info
    lea rsi, [rbp - 152]  ; Space for VkInstanceCreateInfo
    mov DWORD [rsi], VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO  ; sType
    mov QWORD [rsi + 8], 0   ; pNext
    mov DWORD [rsi + 16], 0  ; flags
    mov QWORD [rsi + 24], rdi  ; pApplicationInfo
    
    ; Add validation layers if enabled
    cmp QWORD [validation_layers_enabled], 0
    je .skip_validation
    
    mov QWORD [rsi + 32], [numValidationLayers]  ; enabledLayerCount
    mov QWORD [rsi + 40], validationLayers  ; ppEnabledLayerNames
    jmp .extensions
    
.skip_validation:
    mov QWORD [rsi + 32], 0  ; enabledLayerCount
    mov QWORD [rsi + 40], 0  ; ppEnabledLayerNames
    
.extensions:
    ; Add required extensions
    mov QWORD [rsi + 48], [numInstanceExtensions]  ; enabledExtensionCount
    mov QWORD [rsi + 56], instanceExtensions  ; ppEnabledExtensionNames
    
    ; Create instance
    lea rdx, [rbp - 160]  ; Space for instance handle
    mov rdi, 0  ; No existing instance
    mov rcx, str_vkCreateInstance
    call [vkGetInstanceProcAddr]
    mov rcx, rax  ; vkCreateInstance function pointer
    
    mov rdi, rsi  ; pCreateInfo
    mov rsi, 0    ; pAllocator
    mov rdx, vk_instance  ; pInstance
    call rcx
    
    test rax, rax
    jnz .error
    
    ; Load instance-level function pointers
    call load_instance_functions
    test rax, rax
    jz .error
    
    ; Pick a physical device
    call pick_physical_device
    test rax, rax
    jz .error
    
    ; Success
    mov rax, 1
    jmp .end
    
.error:
    mov rax, 0
    
.end:
    add rsp, 1024
    pop rbp
    ret

; -----------------------------------------------------------------------
; Load Vulkan instance level functions
; -----------------------------------------------------------------------
load_instance_functions:
    push rbp
    mov rbp, rsp
    
    ; Load each function
    mov rdi, [vk_instance]
    mov rsi, str_vkDestroyInstance
    call [vkGetInstanceProcAddr]
    mov [vkDestroyInstance], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_instance]
    mov rsi, str_vkEnumeratePhysicalDevices
    call [vkGetInstanceProcAddr]
    mov [vkEnumeratePhysicalDevices], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_instance]
    mov rsi, str_vkGetPhysicalDeviceProperties
    call [vkGetInstanceProcAddr]
    mov [vkGetPhysicalDeviceProperties], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_instance]
    mov rsi, str_vkGetPhysicalDeviceQueueFamilyProperties
    call [vkGetInstanceProcAddr]
    mov [vkGetPhysicalDeviceQueueFamilyProperties], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_instance]
    mov rsi, str_vkGetPhysicalDeviceSurfaceCapabilitiesKHR
    call [vkGetInstanceProcAddr]
    mov [vkGetPhysicalDeviceSurfaceCapabilitiesKHR], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_instance]
    mov rsi, str_vkGetPhysicalDeviceSurfaceFormatsKHR
    call [vkGetInstanceProcAddr]
    mov [vkGetPhysicalDeviceSurfaceFormatsKHR], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_instance]
    mov rsi, str_vkGetPhysicalDeviceSurfacePresentModesKHR
    call [vkGetInstanceProcAddr]
    mov [vkGetPhysicalDeviceSurfacePresentModesKHR], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_instance]
    mov rsi, str_vkGetPhysicalDeviceSurfaceSupportKHR
    call [vkGetInstanceProcAddr]
    mov [vkGetPhysicalDeviceSurfaceSupportKHR], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_instance]
    mov rsi, str_vkCreateDevice
    call [vkGetInstanceProcAddr]
    mov [vkCreateDevice], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_instance]
    mov rsi, str_vkCreateXcbSurfaceKHR
    call [vkGetInstanceProcAddr]
    mov [vkCreateXcbSurfaceKHR], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_instance]
    mov rsi, str_vkDestroySurfaceKHR
    call [vkGetInstanceProcAddr]
    mov [vkDestroySurfaceKHR], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_instance]
    mov rsi, str_vkGetPhysicalDeviceMemoryProperties
    call [vkGetInstanceProcAddr]
    mov [vkGetPhysicalDeviceMemoryProperties], rax
    test rax, rax
    jz .error
    
    ; Success
    mov rax, 1
    jmp .end
    
.error:
    mov rax, 0
    
.end:
    pop rbp
    ret

; -----------------------------------------------------------------------
; Load Vulkan device level functions
; -----------------------------------------------------------------------
load_device_functions:
    push rbp
    mov rbp, rsp
    
    ; Load each function
    mov rdi, [vk_device]
    mov rsi, str_vkDestroyDevice
    call [vkGetInstanceProcAddr]
    mov [vkDestroyDevice], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkGetDeviceQueue
    call [vkGetInstanceProcAddr]
    mov [vkGetDeviceQueue], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCreateSwapchainKHR
    call [vkGetInstanceProcAddr]
    mov [vkCreateSwapchainKHR], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkDestroySwapchainKHR
    call [vkGetInstanceProcAddr]
    mov [vkDestroySwapchainKHR], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkGetSwapchainImagesKHR
    call [vkGetInstanceProcAddr]
    mov [vkGetSwapchainImagesKHR], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCreateImageView
    call [vkGetInstanceProcAddr]
    mov [vkCreateImageView], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkDestroyImageView
    call [vkGetInstanceProcAddr]
    mov [vkDestroyImageView], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCreateShaderModule
    call [vkGetInstanceProcAddr]
    mov [vkCreateShaderModule], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkDestroyShaderModule
    call [vkGetInstanceProcAddr]
    mov [vkDestroyShaderModule], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCreatePipelineLayout
    call [vkGetInstanceProcAddr]
    mov [vkCreatePipelineLayout], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkDestroyPipelineLayout
    call [vkGetInstanceProcAddr]
    mov [vkDestroyPipelineLayout], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCreateRenderPass
    call [vkGetInstanceProcAddr]
    mov [vkCreateRenderPass], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkDestroyRenderPass
    call [vkGetInstanceProcAddr]
    mov [vkDestroyRenderPass], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCreateGraphicsPipelines
    call [vkGetInstanceProcAddr]
    mov [vkCreateGraphicsPipelines], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkDestroyPipeline
    call [vkGetInstanceProcAddr]
    mov [vkDestroyPipeline], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCreateFramebuffer
    call [vkGetInstanceProcAddr]
    mov [vkCreateFramebuffer], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkDestroyFramebuffer
    call [vkGetInstanceProcAddr]
    mov [vkDestroyFramebuffer], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCreateCommandPool
    call [vkGetInstanceProcAddr]
    mov [vkCreateCommandPool], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkDestroyCommandPool
    call [vkGetInstanceProcAddr]
    mov [vkDestroyCommandPool], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkAllocateCommandBuffers
    call [vkGetInstanceProcAddr]
    mov [vkAllocateCommandBuffers], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkFreeCommandBuffers
    call [vkGetInstanceProcAddr]
    mov [vkFreeCommandBuffers], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkBeginCommandBuffer
    call [vkGetInstanceProcAddr]
    mov [vkBeginCommandBuffer], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCmdBeginRenderPass
    call [vkGetInstanceProcAddr]
    mov [vkCmdBeginRenderPass], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCmdBindPipeline
    call [vkGetInstanceProcAddr]
    mov [vkCmdBindPipeline], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCmdSetViewport
    call [vkGetInstanceProcAddr]
    mov [vkCmdSetViewport], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCmdSetScissor
    call [vkGetInstanceProcAddr]
    mov [vkCmdSetScissor], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCmdDraw
    call [vkGetInstanceProcAddr]
    mov [vkCmdDraw], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCmdDrawIndexed
    call [vkGetInstanceProcAddr]
    mov [vkCmdDrawIndexed], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCmdEndRenderPass
    call [vkGetInstanceProcAddr]
    mov [vkCmdEndRenderPass], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkEndCommandBuffer
    call [vkGetInstanceProcAddr]
    mov [vkEndCommandBuffer], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCreateSemaphore
    call [vkGetInstanceProcAddr]
    mov [vkCreateSemaphore], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkDestroySemaphore
    call [vkGetInstanceProcAddr]
    mov [vkDestroySemaphore], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkCreateFence
    call [vkGetInstanceProcAddr]
    mov [vkCreateFence], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkDestroyFence
    call [vkGetInstanceProcAddr]
    mov [vkDestroyFence], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkResetFences
    call [vkGetInstanceProcAddr]
    mov [vkResetFences], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkWaitForFences
    call [vkGetInstanceProcAddr]
    mov [vkWaitForFences], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkAcquireNextImageKHR
    call [vkGetInstanceProcAddr]
    mov [vkAcquireNextImageKHR], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkQueueSubmit
    call [vkGetInstanceProcAddr]
    mov [vkQueueSubmit], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkQueuePresentKHR
    call [vkGetInstanceProcAddr]
    mov [vkQueuePresentKHR], rax
    test rax, rax
    jz .error
    
    mov rdi, [vk_device]
    mov rsi, str_vkDeviceWaitIdle
    call [vkGetInstanceProcAddr]
    mov [vkDeviceWaitIdle], rax
    test rax, rax
    jz .error
    
    ; Éxito
    mov rax, 1
    jmp .end
    
.error:
    mov rax, 0
.end:
    pop rbp
    ret

; -----------------------------------------------------------------------
; Crea una ventana X11
; -----------------------------------------------------------------------
create_window:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    ; Cargar libX11
    mov rdi, lib_x11
    call dlopen
    test rax, rax
    jz .error
    mov [x11_display], rax
    
    ; Obtener funciones X11
    mov rdi, rax
    mov rsi, str_XOpenDisplay
    call dlsym
    mov [XOpenDisplay], rax
    
    ; Abrir display
    mov rdi, 0  ; NULL para display predeterminado
    call rax
    test rax, rax
    jz .error
    mov [x11_display], rax
    
    ; Obtener conexión XCB
    mov rdi, [x11_display]
    mov rsi, str_XGetXCBConnection
    call dlsym
    mov [XGetXCBConnection], rax
    call rax
    mov [x11_connection], rax
    
    ; Crear ventana
    mov rdi, [x11_display]
    mov rsi, str_XCreateSimpleWindow
    call dlsym
    mov [XCreateSimpleWindow], rax
    
    mov rdi, [x11_display]
    mov rsi, 0  ; Parent
    mov rdx, 0  ; x
    mov rcx, 0  ; y
    mov r8, WINDOW_WIDTH
    mov r9, WINDOW_HEIGHT
    push 0xFFFFFF  ; Borde blanco
    push 0x000000  ; Fondo negro
    push 0         ; Borde ancho
    call rax
    add rsp, 24
    mov [x11_window], rax
    
    ; Establecer título
    mov rdi, [x11_display]
    mov rsi, str_XStoreName
    call dlsym
    mov [XStoreName], rax
    
    mov rdi, [x11_display]
    mov rsi, [x11_window]
    mov rdx, window_title
    call rax
    
    ; Configurar protocolo de cierre
    mov rdi, [x11_display]
    mov rsi, str_XInternAtom
    call dlsym
    mov [XInternAtom], rax
    
    mov rdi, [x11_display]
    mov rsi, atom_wm_protocols
    mov rdx, 1  ; Solo existe
    call rax
    mov [atom_wm_protocols], rax
    
    mov rdi, [x11_display]
    mov rsi, str_XInternAtom
    call dlsym
    mov rdi, [x11_display]
    mov rsi, atom_wm_delete_window
    mov rdx, 0
    call rax
    mov [atom_wm_delete_window], rax
    
    ; Establecer WM_PROTOCOLS
    mov rdi, [x11_display]
    mov rsi, str_XSetWMProtocols
    call dlsym
    mov [XSetWMProtocols], rax
    
    mov rdi, [x11_display]
    mov rsi, [x11_window]
    lea rdx, [atom_wm_delete_window]
    mov rcx, 1
    call rax
    
    ; Mostrar ventana
    mov rdi, [x11_display]
    mov rsi, str_XMapWindow
    call dlsym
    mov [XMapWindow], rax
    
    mov rdi, [x11_display]
    mov rsi, [x11_window]
    call rax
    
    ; Éxito
    mov rax, 1
    jmp .end
    
.error:
    mov rax, 0
.end:
    add rsp, 32
    pop rbp
    ret

; -----------------------------------------------------------------------
; Bucle principal de renderizado
; -----------------------------------------------------------------------
main_loop:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    
.loop:
    ; Procesar eventos X11
    mov rdi, [x11_display]
    mov rsi, str_XPending
    call dlsym
    mov rdi, [x11_display]
    call rax
    test eax, eax
    jz .render
    
    ; Obtener evento
    mov rdi, [x11_display]
    mov rsi, str_XNextEvent
    call dlsym
    lea rdi, [x_event]
    call rax
    
    ; Verificar cierre
    mov al, [x_event]
    cmp al, 33  ; ClientMessage
    jne .render
    
    ; Salir
    jmp .exit_loop
    
.render:
    ; Esperar a que la GPU termine el frame actual
    mov rdi, [vk_device]
    mov rsi, [in_flight_fences + 8*rax]  ; current_frame
    mov rdx, 1
    mov rcx, 0xFFFFFFFFFFFFFFFF
    call [vkWaitForFences]
    
    ; Adquirir imagen de la swapchain
    mov rdi, [vk_device]
    mov rsi, [vk_swapchain]
    mov rdx, 0xFFFFFFFFFFFFFFFF
    mov rcx, [image_available_semaphores + 8*rax]
    mov r8, 0
    lea r9, [swapchain_image_index]
    call [vkAcquireNextImageKHR]
    test rax, rax
    jnz .error
    
    ; Reiniciar la valla
    mov rdi, [vk_device]
    mov rsi, 1
    lea rdx, [in_flight_fences + 8*rax]
    call [vkResetFences]
    
    ; Grabar comandos
    mov rdi, [command_buffers + 8*rax]
    call record_command_buffer
    
    ; Enviar a la cola
    mov rdi, [vk_graphics_queue]
    mov rsi, 1
    lea rdx, [submit_info]
    mov rcx, [in_flight_fences + 8*rax]
    call [vkQueueSubmit]
    
    ; Presentar
    lea rdi, [present_info]
    mov QWORD [rdi], VK_STRUCTURE_TYPE_PRESENT_INFO_KHR
    mov QWORD [rdi+8], 0
    mov QWORD [rdi+16], 1
    lea rax, [render_finished_semaphores + 8*rax]
    mov QWORD [rdi+24], rax
    mov QWORD [rdi+32], 1
    lea rax, [vk_swapchain]
    mov QWORD [rdi+40], rax
    lea rax, [swapchain_image_index]
    mov QWORD [rdi+48], rax
    mov QWORD [rdi+56], 0
    
    mov rdi, [vk_present_queue]
    call [vkQueuePresentKHR]
    
    ; Actualizar frame
    mov rax, [current_frame]
    inc rax
    xor rdx, rdx
    div QWORD [max_frames_in_flight]
    mov [current_frame], rdx
    
    jmp .loop
    
.exit_loop:
    ; Esperar a que el dispositivo esté inactivo
    mov rdi, [vk_device]
    call [vkDeviceWaitIdle]
    
    add rsp, 64
    pop rbp
    ret

.error:
    ; Manejar error
    add rsp, 64
    pop rbp
    ret

; -----------------------------------------------------------------------
; Función para grabar comandos en el buffer
; -----------------------------------------------------------------------
record_command_buffer:
    push rbp
    mov rbp, rsp
    
    ; Iniciar buffer de comandos
    lea rdi, [begin_info]
    mov DWORD [rdi], VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO
    mov QWORD [rdi+8], 0
    mov DWORD [rdi+16], 0  ; flags
    mov QWORD [rdi+24], 0
    
    mov rsi, rdi
    mov rdi, [command_buffers + 8*rax]  ; current buffer
    call [vkBeginCommandBuffer]
    
    ; Iniciar render pass
    lea rdi, [render_pass_begin_info]
    mov DWORD [rdi], VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO
    mov QWORD [rdi+8], 0
    mov rax, [vk_render_pass]
    mov QWORD [rdi+16], rax
    mov rax, [swapchain_framebuffers + 8*rax]  ; current framebuffer
    mov QWORD [rdi+24], rax
    mov QWORD [rdi+32], 0  ; offset x
    mov QWORD [rdi+40], 0  ; offset y
    mov rax, [swapchain_extent]
    mov QWORD [rdi+48], rax  ; width
    mov QWORD [rdi+56], [swapchain_extent+8]  ; height
    mov QWORD [rdi+64], 1  ; clearValueCount
    lea rax, [clear_color]
    mov QWORD [rdi+72], rax
    
    mov rdi, [command_buffers + 8*rax]
    mov rsi, rdi  ; pRenderPassBegin
    mov rdx, VK_SUBPASS_CONTENTS_INLINE
    call [vkCmdBeginRenderPass]
    
    ; Vincular pipeline
    mov rdi, [command_buffers + 8*rax]
    mov rsi, VK_PIPELINE_BIND_POINT_GRAPHICS
    mov rdx, [vk_graphics_pipeline]
    call [vkCmdBindPipeline]
    
    ; Establecer viewport y scissor
    lea rdi, [viewport]
    mov rax, [swapchain_extent]
    mov [rdi], rax  ; width
    mov rax, [swapchain_extent+8]
    mov [rdi+8], rax  ; height
    mov QWORD [rdi+16], 0x0  ; minDepth
    mov QWORD [rdi+24], 0x3F800000  ; maxDepth (1.0)
    
    mov rdi, [command_buffers + 8*rax]
    mov rsi, 0  ; firstViewport
    mov rdx, 1  ; viewportCount
    lea rcx, [viewport]
    call [vkCmdSetViewport]
    
    lea rdi, [scissor]
    mov QWORD [rdi], 0  ; offset x
    mov QWORD [rdi+8], 0  ; offset y
    mov rax, [swapchain_extent]
    mov [rdi+16], rax  ; width
    mov rax, [swapchain_extent+8]
    mov [rdi+24], rax  ; height
    
    mov rdi, [command_buffers + 8*rax]
    mov rsi, 0  ; firstScissor
    mov rdx, 1  ; scissorCount
    lea rcx, [scissor]
    call [vkCmdSetScissor]
    
    ; Dibujar cubo
    mov rdi, [command_buffers + 8*rax]
    mov rsi, indices_count  ; índice count
    mov rdx, 1  ; instanceCount
    mov rcx, 0  ; firstIndex
    mov r8, 0   ; vertexOffset
    mov r9, 0   ; firstInstance
    call [vkCmdDrawIndexed]
    
    ; Finalizar render pass
    mov rdi, [command_buffers + 8*rax]
    call [vkCmdEndRenderPass]
    
    ; Finalizar buffer de comandos
    mov rdi, [command_buffers + 8*rax]
    call [vkEndCommandBuffer]
    
    pop rbp
    ret

;-----------------------------------------------------------------------
; Crea la swapchain de Vulkan
;-----------------------------------------------------------------------
create_swapchain:
    push rbp
    mov rbp, rsp
    sub rsp, 512

    ; Obtener capacidades de la superficie
    mov rdi, [vk_physical_device]
    mov rsi, [vk_surface]
    lea rdx, [surface_capabilities]
    call [vkGetPhysicalDeviceSurfaceCapabilitiesKHR]
    test rax, rax
    jnz .error

    ; Seleccionar formato de superficie (priorizar SRGB)
    mov rdi, [vk_physical_device]
    mov rsi, [vk_surface]
    lea rdx, [surface_format_count]
    lea rcx, [surface_formats]
    call [vkGetPhysicalDeviceSurfaceFormatsKHR]
    test rax, rax
    jnz .error

    ; Configurar estructura de creación de swapchain
    lea rdi, [swapchain_create_info]
    mov DWORD [rdi], VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR  ; sType
    mov QWORD [rdi+8], 0                                          ; pNext
    mov QWORD [rdi+16], 0                                         ; flags
    mov rax, [vk_surface]
    mov QWORD [rdi+24], rax                                       ; surface
    mov eax, [surface_capabilities + 16]                          ; minImageCount
    inc eax
    mov DWORD [rdi+32], eax                                       ; minImageCount
    mov eax, [surface_formats + 0]                                ; formato
    mov DWORD [rdi+40], eax                                       ; imageFormat
    mov eax, [surface_formats + 4]                                ; colorSpace
    mov DWORD [rdi+44], eax                                       ; imageColorSpace
    mov rax, [surface_capabilities + 0]                           ; currentExtent
    mov QWORD [rdi+48], rax                                       ; imageExtent
    mov DWORD [rdi+56], 1                                         ; imageArrayLayers
    mov DWORD [rdi+60], VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT       ; imageUsage
    mov DWORD [rdi+64], VK_SHARING_MODE_EXCLUSIVE                 ; imageSharingMode
    mov DWORD [rdi+68], 0                                         ; queueFamilyIndexCount
    mov QWORD [rdi+72], 0                                         ; pQueueFamilyIndices
    mov DWORD [rdi+80], VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR     ; preTransform
    mov DWORD [rdi+84], VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR         ; compositeAlpha
    mov DWORD [rdi+88], VK_PRESENT_MODE_FIFO_KHR                  ; presentMode
    mov DWORD [rdi+92], 1                                         ; clipped
    mov QWORD [rdi+96], 0                                         ; oldSwapchain

    ; Crear swapchain
    mov rdi, [vk_device]
    lea rsi, [swapchain_create_info]
    mov rdx, 0
    lea rcx, [vk_swapchain]
    call [vkCreateSwapchainKHR]
    test rax, rax
    jnz .error

    ; Obtener imágenes de la swapchain
    mov rdi, [vk_device]
    mov rsi, [vk_swapchain]
    lea rdx, [swapchain_image_count]
    mov rcx, 0
    call [vkGetSwapchainImagesKHR]
    test rax, rax
    jnz .error

    ; Reservar memoria para las imágenes
    mov rax, [swapchain_image_count]
    shl rax, 3  ; sizeof(VkImage*)
    mov rdi, rax
    call malloc
    mov [swapchain_images], rax

    ; Obtener imágenes
    mov rdi, [vk_device]
    mov rsi, [vk_swapchain]
    lea rdx, [swapchain_image_count]
    mov rcx, [swapchain_images]
    call [vkGetSwapchainImagesKHR]

    ; Éxito
    mov rax, 1
    jmp .end

.error:
    mov rax, 0
.end:
    add rsp, 512
    pop rbp
    ret

; Que hago con mi vida

;-----------------------------------------------------------------------
; Crea las vistas de imagen para la swapchain
;-----------------------------------------------------------------------
create_image_views:
    push rbp
    mov rbp, rsp
    sub rsp, 256

    ; Reservar memoria para las vistas
    mov rax, [swapchain_image_count]
    shl rax, 3  ; sizeof(VkImageView*)
    mov rdi, rax
    call malloc
    mov [swapchain_image_views], rax

    ; Crear vista para cada imagen
    xor rbx, rbx  ; contador
.loop:
    cmp rbx, [swapchain_image_count]
    jge .end

    ; Configurar estructura de creación de vista
    lea rdi, [image_view_create_info]
    mov DWORD [rdi], VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO  ; sType
    mov QWORD [rdi+8], 0                                      ; pNext
    mov DWORD [rdi+16], 0                                     ; flags
    mov rax, [swapchain_images + rbx*8]
    mov QWORD [rdi+24], rax                                   ; image
    mov DWORD [rdi+32], VK_IMAGE_VIEW_TYPE_2D                 ; viewType
    mov eax, [swapchain_image_format]
    mov DWORD [rdi+36], eax                                   ; format
    mov DWORD [rdi+40], 0x00000000                            ; components.r
    mov DWORD [rdi+44], 0x00000000                            ; components.g
    mov DWORD [rdi+48], 0x00000000                            ; components.b
    mov DWORD [rdi+52], 0x00000000                            ; components.a
    mov DWORD [rdi+56], VK_IMAGE_ASPECT_COLOR_BIT             ; subresourceRange.aspectMask
    mov DWORD [rdi+60], 0                                     ; subresourceRange.baseMipLevel
    mov DWORD [rdi+64], 1                                     ; subresourceRange.levelCount
    mov DWORD [rdi+68], 0                                     ; subresourceRange.baseArrayLayer
    mov DWORD [rdi+72], 1                                     ; subresourceRange.layerCount

    ; Crear image view
    mov rdi, [vk_device]
    lea rsi, [image_view_create_info]
    mov rdx, 0
    lea rcx, [swapchain_image_views + rbx*8]
    call [vkCreateImageView]
    test rax, rax
    jnz .error

    inc rbx
    jmp .loop

.error:
    mov rax, 0
.end:
    add rsp, 256
    pop rbp
    ret
    
; Me duele la cabeza

;-----------------------------------------------------------------------
; Crea el buffer de vértices en la GPU
;-----------------------------------------------------------------------
create_vertex_buffer:
    push rbp
    mov rbp, rsp
    sub rsp, 256

    ; Crear buffer
    lea rdi, [buffer_info]
    mov DWORD [rdi], VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO  ; sType
    mov QWORD [rdi+8], 0                                  ; pNext
    mov QWORD [rdi+16], 0                                 ; flags
    mov QWORD [rdi+24], vertices_size                     ; size
    mov DWORD [rdi+32], VK_BUFFER_USAGE_VERTEX_BUFFER_BIT ; usage
    mov DWORD [rdi+36], VK_SHARING_MODE_EXCLUSIVE         ; sharingMode

    mov rsi, rdi
    mov rdi, [vk_device]
    mov rdx, 0
    lea rcx, [vk_vertex_buffer]
    call [vkCreateBuffer]
    test rax, rax
    jnz .error

    ; Obtener requisitos de memoria
    mov rdi, [vk_device]
    mov rsi, [vk_vertex_buffer]
    lea rdx, [mem_requirements]
    call [vkGetBufferMemoryRequirements]

    ; Asignar memoria
    lea rdi, [alloc_info]
    mov DWORD [rdi], VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO
    mov QWORD [rdi+8], 0
    mov rax, [mem_requirements + 0]  ; size
    mov QWORD [rdi+16], rax
    mov eax, [mem_requirements + 16] ; memoryTypeBits
    mov DWORD [rdi+24], eax

    mov rsi, rdi
    mov rdi, [vk_device]
    lea rdx, [vk_vertex_buffer_memory]
    call [vkAllocateMemory]
    test rax, rax
    jnz .error

    ; Vincular memoria
    mov rdi, [vk_device]
    mov rsi, [vk_vertex_buffer]
    mov rdx, [vk_vertex_buffer_memory]
    mov rcx, 0  ; offset
    call [vkBindBufferMemory]

    ; Copiar datos
    mov rdi, [vk_device]
    mov rsi, [vk_vertex_buffer_memory]
    mov rdx, 0  ; offset
    mov rcx, vertices_size
    mov r8, 0   ; flags
    lea r9, [mapped_ptr]
    call [vkMapMemory]

    mov rdi, [mapped_ptr]
    mov rsi, vertices_data
    mov rcx, vertices_size
    rep movsb

    mov rdi, [vk_device]
    mov rsi, [vk_vertex_buffer_memory]
    call [vkUnmapMemory]

    ; Éxito
    mov rax, 1
    jmp .end

.error:
    mov rax, 0
.end:
    add rsp, 256
    pop rbp
    ret

; El create_index_buffer (cambiar vertices -> indices)
; Acuerdate de esto coño, que siempre se te olvida ^

;-----------------------------------------------------------------------
; Crea el buffer de índices en la GPU
;-----------------------------------------------------------------------
create_index_buffer:
    push rbp
    mov rbp, rsp
    sub rsp, 256

    ; Crear buffer
    lea rdi, [buffer_info]
    mov DWORD [rdi], VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO  ; sType
    mov QWORD [rdi+8], 0                                  ; pNext
    mov QWORD [rdi+16], 0                                 ; flags
    mov QWORD [rdi+24], indices_size                      ; size
    mov DWORD [rdi+32], VK_BUFFER_USAGE_INDEX_BUFFER_BIT  ; usage
    mov DWORD [rdi+36], VK_SHARING_MODE_EXCLUSIVE         ; sharingMode

    mov rsi, rdi
    mov rdi, [vk_device]
    mov rdx, 0
    lea rcx, [vk_index_buffer]
    call [vkCreateBuffer]
    test rax, rax
    jnz .error

    ; Obtener requisitos de memoria (usar misma lógica que create_vertex_buffer)
    ; ... código idéntico a create_vertex_buffer pero con vk_index_buffer ...

    ; Éxito
    mov rax, 1
    jmp .end

.error:
    mov rax, 0
.end:
    add rsp, 256
    pop rbp
    ret

;-----------------------------------------------------------------------
; Crea los módulos de shaders desde el código SPIR-V
;-----------------------------------------------------------------------
create_shader_modules:
    push rbp
    mov rbp, rsp

    ; Shader de vértices
    lea rdi, [shader_module_info]
    mov DWORD [rdi], VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO
    mov QWORD [rdi+8], 0
    mov QWORD [rdi+16], vertex_shader_size
    lea rax, [vertex_shader_code]
    mov QWORD [rdi+24], rax

    mov rdi, [vk_device]
    lea rsi, [shader_module_info]
    mov rdx, 0
    lea rcx, [vertex_shader_module]
    call [vkCreateShaderModule]

    ; Shader de fragmentos
    lea rdi, [shader_module_info]
    mov QWORD [rdi+16], fragment_shader_size
    lea rax, [fragment_shader_code]
    mov QWORD [rdi+24], rax

    mov rdi, [vk_device]
    lea rsi, [shader_module_info]
    mov rdx, 0
    lea rcx, [fragment_shader_module]
    call [vkCreateShaderModule]

    ; Verificar errores
    cmp QWORD [vertex_shader_module], 0
    je .error
    cmp QWORD [fragment_shader_module], 0
    je .error

    mov rax, 1
    jmp .end

.error:
    mov rax, 0
.end:
    pop rbp
    ret
    
;-----------------------------------------------------------------------
; Crea el pipeline layout mínimo requerido
;-----------------------------------------------------------------------
create_pipeline_layout:
    push rbp
    mov rbp, rsp

    lea rdi, [pipeline_layout_info]
    mov DWORD [rdi], VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO
    mov QWORD [rdi+8], 0
    mov QWORD [rdi+16], 0  ; setLayoutCount
    mov QWORD [rdi+24], 0  ; pSetLayouts
    mov QWORD [rdi+32], 0  ; pushConstantRangeCount
    mov QWORD [rdi+40], 0  ; pPushConstantRanges

    mov rdi, [vk_device]
    lea rsi, [pipeline_layout_info]
    mov rdx, 0
    lea rcx, [vk_pipeline_layout]
    call [vkCreatePipelineLayout]

    test rax, rax
    jnz .error
    mov rax, 1
    jmp .end

.error:
    mov rax, 0
.end:
    pop rbp
    ret

; ayuda

;-----------------------------------------------------------------------
; Crea el render pass de Vulkan
;-----------------------------------------------------------------------
create_render_pass:
    push rbp
    mov rbp, rsp
    sub rsp, 512

    ; Configurar attachment description
    lea rdi, [color_attachment]
    mov DWORD [rdi], VK_FORMAT_B8G8R8A8_SRGB         ; format
    mov DWORD [rdi+4], VK_SAMPLE_COUNT_1_BIT        ; samples
    mov DWORD [rdi+8], VK_ATTACHMENT_LOAD_OP_CLEAR   ; loadOp
    mov DWORD [rdi+12], VK_ATTACHMENT_STORE_OP_STORE ; storeOp
    mov DWORD [rdi+16], VK_ATTACHMENT_LOAD_OP_DONT_CARE ; stencilLoadOp
    mov DWORD [rdi+20], VK_ATTACHMENT_STORE_OP_DONT_CARE ; stencilStoreOp
    mov DWORD [rdi+24], VK_IMAGE_LAYOUT_UNDEFINED   ; initialLayout
    mov DWORD [rdi+28], VK_IMAGE_LAYOUT_PRESENT_SRC_KHR ; finalLayout

    ; Configurar attachment reference
    lea rsi, [color_attachment_ref]
    mov DWORD [rsi], 0                              ; attachment
    mov DWORD [rsi+4], VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL ; layout

    ; Configurar subpass description
    lea rdx, [subpass]
    mov DWORD [rdx], 0                              ; flags
    mov DWORD [rdx+4], VK_PIPELINE_BIND_POINT_GRAPHICS ; pipelineBindPoint
    mov QWORD [rdx+8], 0                            ; inputAttachmentCount
    mov QWORD [rdx+16], 1                           ; colorAttachmentCount
    mov QWORD [rdx+24], rsi                         ; pColorAttachments
    mov QWORD [rdx+32], 0                           ; pResolveAttachments
    mov QWORD [rdx+40], 0                           ; pDepthStencilAttachment
    mov QWORD [rdx+48], 0                           ; preserveAttachmentCount
    mov QWORD [rdx+56], 0                           ; pPreserveAttachments

    ; Configurar render pass create info
    lea rcx, [render_pass_info]
    mov DWORD [rcx], VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO ; sType
    mov QWORD [rcx+8], 0                            ; pNext
    mov QWORD [rcx+16], 0                            ; flags
    mov QWORD [rcx+24], 1                            ; attachmentCount
    mov QWORD [rcx+32], rdi                          ; pAttachments
    mov QWORD [rcx+40], 1                            ; subpassCount
    mov QWORD [rcx+48], rdx                          ; pSubpasses
    mov QWORD [rcx+56], 0                            ; dependencyCount
    mov QWORD [rcx+64], 0                            ; pDependencies

    ; Crear render pass
    mov rdi, [vk_device]
    lea rsi, [render_pass_info]
    mov rdx, 0
    lea rcx, [vk_render_pass]
    call [vkCreateRenderPass]

    test rax, rax
    jnz .error
    mov rax, 1
    jmp .end

.error:
    mov rax, 0
.end:
    add rsp, 512
    pop rbp
    ret

; Lalalalalalamamamamamlalllalalal


; En record_command_buffer:
    ; Vincular buffers
    mov rdi, [command_buffers + 8*rax]
    mov rsi, 0  ; firstBinding
    mov rdx, 1  ; bindingCount
    lea rcx, [vk_vertex_buffer]
    lea r8, [vertex_offsets]
    call [vkCmdBindVertexBuffers]

    mov rdi, [command_buffers + 8*rax]
    mov rsi, [vk_index_buffer]
    mov rdx, 0  ; offset
    mov rcx, VK_INDEX_TYPE_UINT16
    call [vkCmdBindIndexBuffer]
    
; En cleanup_swapchain:
    ; Destruir framebuffers
    mov rbx, [swapchain_image_count]
.destroy_framebuffers:
    dec rbx
    js .destroy_image_views
    
    mov rdi, [vk_device]
    mov rsi, [swapchain_framebuffers + rbx*8]
    call [vkDestroyFramebuffer]
    jmp .destroy_framebuffers

.destroy_image_views:
    ; no me acuerdo de que hay que poner aquí , pero se que es un codiódigo de antes

    ; Destruir render pass
    mov rdi, [vk_device]
    mov rsi, [vk_render_pass]
    call [vkDestroyRenderPass]

; En cleanup:
    ; Destruir buffers
    mov rdi, [vk_device]
    mov rsi, [vk_vertex_buffer]
    call [vkDestroyBuffer]
    mov rdi, [vk_device]
    mov rsi, [vk_vertex_buffer_memory]
    call [vkFreeMemory]

    ; Destruir shaders
    mov rdi, [vk_device]
    mov rsi, [vertex_shader_module]
    call [vkDestroyShaderModule]
    mov rdi, [vk_device]
    mov rsi, [fragment_shader_module]
    call [vkDestroyShaderModule]

    ; Destruir pipeline layout
    mov rdi, [vk_device]
    mov rsi, [vk_pipeline_layout]
    call [vkDestroyPipelineLayout]

; -----------------------------------------------------------------------
; Limpieza de recursos
; -----------------------------------------------------------------------
cleanup:
    ; Destruir sincronización
    mov rcx, [max_frames_in_flight]
.cleanup_sync:
    dec rcx
    js .cleanup_swapchain
    
    mov rdi, [vk_device]
    mov rsi, [image_available_semaphores + rcx*8]
    call [vkDestroySemaphore]
    
    mov rdi, [vk_device]
    mov rsi, [render_finished_semaphores + rcx*8]
    call [vkDestroySemaphore]
    
    mov rdi, [vk_device]
    mov rsi, [in_flight_fences + rcx*8]
    call [vkDestroyFence]
    
    jmp .cleanup_sync

.cleanup_swapchain:
    ; Destruir framebuffers, image views, swapchain
    ; ... [Implementación similar al código Vulkan estándar] ...
    
    ; Destruir ventana X11
    mov rdi, [x11_display]
    mov rsi, [x11_window]
    call [XDestroyWindow]
    
    mov rdi, [x11_display]
    call [XCloseDisplay]
    
    ; Destruir instancia Vulkan
    mov rdi, [vk_instance]
    call [vkDestroyInstance]
    
    ret